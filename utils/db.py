from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    # Fallback or error, but for now let's just warn or set a dummy one if running locally without env
    print("Warning: DATABASE_URL not set. Database operations will fail.")
    DATABASE_URL = "mysql+pymysql://root:12345@localhost:3306/pentest_db"

# Ensure URL starts with postgresql:// (SQLAlchemy 1.4+ requirement)
if DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

# Create engine without SSL requirements for MySQL
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
