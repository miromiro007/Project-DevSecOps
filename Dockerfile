FROM python:3.11-slim

LABEL maintainer="FUSE Security Scanner"
LABEL description="Automated Pentesting Platform with Modern Web UI"
LABEL version="2.0"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies and security tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    libcap2-bin \
    git \
    curl \
    wget \
    libpq-dev \
    gcc \
    build-essential \
    netcat-openbsd \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Allow non-root to run Nmap with required network capabilities
RUN setcap cap_net_raw,cap_net_admin=eip /usr/bin/nmap

# Create non-root user for security
RUN useradd -m -u 1000 pentest && mkdir -p /app && chown -R pentest:pentest /app

WORKDIR /app

# Copy requirements and install Python dependencies
COPY --chown=pentest:pentest requirements.txt .
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=pentest:pentest . .

# Create necessary directories (including static for frontend)
RUN mkdir -p /app/logs /app/reports /app/uploads /app/static && \
    chown -R pentest:pentest /app/logs /app/reports /app/uploads /app/static

# Ensure frontend files are present
RUN if [ ! -f /app/frontend/index.html ]; then \
    echo "Warning: Frontend files not found in frontend/"; \
    fi

# Switch to non-root user
USER pentest

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
