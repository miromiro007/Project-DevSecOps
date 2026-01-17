import asyncio
import os
import json
from datetime import datetime
from groq import Groq
from typing import Dict, Any
from sqlalchemy.orm import Session
from utils.db import SessionLocal, engine, Base
from models import ScanResult

# Ensure tables exist (simple migration for demo)
try:
    Base.metadata.create_all(bind=engine)
except Exception as e:
    print(f"Warning: Could not connect to database to create tables. {e}")


def _generate_report_with_groq(prompt: str, log_callback) -> str | None:
    """Generate report using Groq API (free, no credit card required)."""
    groq_key = os.getenv("GROQ_API_KEY")
    if not groq_key:
        log_callback("GROQ_API_KEY not set, skipping Groq.")
        return None
    
    try:
        log_callback("Attempting AI report generation with Groq (free)...")
        client = Groq(api_key=groq_key)
        response = client.chat.completions.create(
            model="llama-3.3-70b-versatile",  # Free tier model on Groq (fast and capable)
            max_tokens=2048,
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        log_callback("AI Report generated successfully using Groq (free).")
        return response.choices[0].message.content
    except Exception as e:
        log_callback(f"Groq generation failed: {str(e)}")
        return None




async def run_reporting(scan_results: Dict[str, Any], log_callback) -> None:
    """
    Step 6: Reporting
    Generates an AI report using Groq (free) or Gemini (if available).
    Saves results to the database.
    """
    log_callback("Generating Final Report with AI...")
    
    vulns = scan_results.get("vulns", 0)
    open_ports = scan_results["results"].get("open_ports", [])
    headers = scan_results["results"].get("headers", {})
    target_url = scan_results.get("target_url", "Unknown Target")
    
    prompt = f"""
    Act as a Senior Cybersecurity Consultant. Generate a formal Penetration Testing Report for {target_url} based on the following scan data.
    
    Scan Data:
    - Target: {target_url}
    - Open Ports: {', '.join(map(str, open_ports)) if open_ports else 'None detected'}
    - Vulnerabilities Detected: {vulns}
    - Server Headers: {json.dumps(headers)}
    
    The report must follow industry standards (like PTES or OSSTMM) and be formatted clearly for both management and technical teams. Use the following structure:

    # Penetration Testing Report
    **Target:** {target_url}
    **Date:** {datetime.now().strftime("%Y-%m-%d")}

    ## 1. Executive Summary
    (A non-technical overview of the security posture, key risks, and business impact. Suitable for C-level executives.)

    ## 2. Scope & Methodology
    (Briefly describe the scope (External Blackbox) and methodology (OWASP/NIST based).)

    ## 3. Summary of Findings
    (A summary table or list categorizing findings by severity: Critical, High, Medium, Low, Informational. Since you only have a count, estimate the severity based on typical findings for the detected open ports/headers or generic best practices if specific vuln details are missing.)

    ## 4. Technical Findings & Recommendations
    (For each key finding/risk area based on the data:)
    *   **Finding:** [Name of Issue]
    *   **Severity:** [Severity Level]
    *   **Description:** [Technical explanation]
    *   **Business Impact:** [What happens if exploited]
    *   **Remediation:** [Specific technical steps to fix]

    ## 5. Conclusion
    (Final thoughts on the overall security maturity.)

    Do not use markdown code blocks for the whole report, just standard markdown formatting.
    """
    
    # Generate report using Groq (free, no credit card required)
    ai_report_text = _generate_report_with_groq(prompt, log_callback)
    
    # Default message if Groq fails
    if ai_report_text is None:
        ai_report_text = (
            "AI report generation failed.\n\n"
            "To enable:\n"
            "1. Get GROQ_API_KEY (free, no credit card): https://console.groq.com/\n"
            "2. Add it to .env file as: GROQ_API_KEY=your_key_here\n"
            "3. Restart the application\n\n"
            "Scan completed; AI report generation requires Groq configuration."
        )
        log_callback("GROQ_API_KEY not configured or Groq API call failed.")

    # Add report to results so frontend can retrieve it
    scan_results["results"]["ai_report"] = ai_report_text

    # 2. Save to Database
    log_callback("Saving results to database...")
    try:
        db: Session = SessionLocal()
        db_scan = ScanResult(
            id=scan_results["id"],
            target_url=target_url,
            status="completed",
            vulns_count=vulns,
            scan_data=scan_results["results"],
            ai_report=ai_report_text
        )
        db.add(db_scan)
        db.commit()
        db.refresh(db_scan)
        db.close()
        log_callback("Results saved to database successfully.")
    except Exception as e:
        log_callback(f"Database Error: {str(e)}")
    
    scan_results["status"] = "completed"
    log_callback("Pentest Completed Successfully.")
    
    await asyncio.sleep(1)
