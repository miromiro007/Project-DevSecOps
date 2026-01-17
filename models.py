from sqlalchemy import Column, Integer, String, JSON, DateTime, Text
from utils.db import Base
from datetime import datetime

class ScanResult(Base):
    __tablename__ = "scan_results"

    id = Column(String(255), primary_key=True, index=True)
    target_url = Column(String(500), index=True)
    status = Column(String(50))
    vulns_count = Column(Integer)
    scan_data = Column(JSON) # Stores the full results dict
    ai_report = Column(Text) # Stores the Gemini generated report
    created_at = Column(DateTime, default=datetime.utcnow)
