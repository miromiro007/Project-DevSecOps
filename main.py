from fastapi import FastAPI, BackgroundTasks, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
import uuid
import os
import asyncio
from typing import Dict, List
from datetime import datetime
from pathlib import Path
from workflow import (
    run_footprinting,
    run_scanning,
    run_exploitation,
    run_post_exploitation,
    run_persistence,
    run_reporting
)

app = FastAPI(title="FUSE Security Scanner API")

# Enable CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files (frontend directory)
static_path = Path(__file__).parent / "frontend"
static_path.mkdir(exist_ok=True)
app.mount("/static", StaticFiles(directory=str(static_path)), name="static")

# In-memory storage for scan results
scans: Dict[str, Dict] = {}

class ScanRequest(BaseModel):
    target_url: str

class ScanStatus(BaseModel):
    id: str
    status: str
    step: int
    logs: List[str]
    vulns: int
    results: Dict

async def perform_pentest(scan_id: str, target_url: str):
    scans[scan_id]["status"] = "running"
    domain = target_url.replace("https://", "").replace("http://", "").split("/")[0]
    
    # Helper to add log
    def add_log(msg: str):
        timestamp = datetime.now().strftime("%H:%M:%S")
        scans[scan_id]["logs"].append(f"[{timestamp}] {msg}")

    try:
        # Step 1: Footprinting
        scans[scan_id]["step"] = 0
        await run_footprinting(target_url, scans[scan_id], add_log)

        # Step 2: Scanning
        scans[scan_id]["step"] = 1
        await run_scanning(domain, scans[scan_id], add_log)

        # Step 3: Exploitation
        scans[scan_id]["step"] = 2
        await run_exploitation(scans[scan_id], add_log)

        # Step 4: Post-Exploitation
        scans[scan_id]["step"] = 3
        await run_post_exploitation(scans[scan_id], add_log)

        # Step 5: Persistence & Escalation
        scans[scan_id]["step"] = 4
        await run_persistence(scans[scan_id], add_log)

        # Step 6: Reporting
        scans[scan_id]["step"] = 5
        await run_reporting(scans[scan_id], add_log)

    except Exception as e:
        scans[scan_id]["status"] = "failed"
        add_log(f"Critical Error: {str(e)}")

@app.post("/scan", response_model=Dict)
async def start_scan(request: ScanRequest, background_tasks: BackgroundTasks):
    scan_id = str(uuid.uuid4())
    scans[scan_id] = {
        "id": scan_id,
        "target_url": request.target_url,
        "status": "pending",
        "step": -1,
        "logs": [],
        "vulns": 0,
        "results": {}
    }
    background_tasks.add_task(perform_pentest, scan_id, request.target_url)
    return {"scan_id": scan_id, "message": "Scan started"}

@app.get("/status/{scan_id}", response_model=ScanStatus)
async def get_status(scan_id: str):
    if scan_id not in scans:
        raise HTTPException(status_code=404, detail="Scan not found")
    return scans[scan_id]

@app.get("/health")
async def health_check():
    return {"status": "healthy"}


@app.get("/debug/ai")
async def debug_ai(
    prompt: str = "Reply with exactly: OK",
    x_debug_token: str | None = Header(default=None, alias="X-Debug-Token"),
):
    """Debug endpoint to verify Gemini connectivity.

    Disabled by default. Enable explicitly with ENABLE_AI_DEBUG=1 and set AI_DEBUG_TOKEN.
    """
    if os.getenv("ENABLE_AI_DEBUG") != "1":
        raise HTTPException(status_code=404, detail="Not found")

    expected = os.getenv("AI_DEBUG_TOKEN")
    if not expected:
        raise HTTPException(
            status_code=503,
            detail="AI debug not configured (AI_DEBUG_TOKEN not set).",
        )
    if not x_debug_token or x_debug_token != expected:
        raise HTTPException(status_code=401, detail="Unauthorized")

    gemini_key = os.getenv("GEMINI_API_KEY")
    if not gemini_key:
        return {
            "ok": False,
            "reason": "GEMINI_API_KEY not set",
        }

    model_name = os.getenv("GEMINI_MODEL", "gemini-2.0-flash")
    try:
        import google.generativeai as genai

        genai.configure(api_key=gemini_key)
        model = genai.GenerativeModel(model_name)
        response = await asyncio.wait_for(
            model.generate_content_async(prompt),
            timeout=float(os.getenv("AI_DEBUG_TIMEOUT_SECONDS", "15")),
        )
        return {
            "ok": True,
            "model": model_name,
            "text": (response.text or "").strip()[:500],
        }
    except asyncio.TimeoutError:
        return {
            "ok": False,
            "model": model_name,
            "error_type": "TimeoutError",
            "error": "Gemini request timed out. This can happen during quota/rate-limit retries.",
        }
    except Exception as e:
        return {
            "ok": False,
            "model": model_name,
            "error_type": type(e).__name__,
            "error": str(e)[:1000],
        }

@app.get("/")
async def root():
    """Serve the frontend application"""
    return FileResponse(static_path / "index.html")

# Serve the frontend directory at the web root so relative assets like
# /styles.css and /app.js load correctly when accessing the API directly.
# This is added after API routes so it won't shadow endpoints like /scan.
app.mount("/", StaticFiles(directory=str(static_path), html=True), name="frontend")
