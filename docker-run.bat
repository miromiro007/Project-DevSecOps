@echo off
REM =========================================
REM Docker Containerization Launch Script
REM =========================================
color 0A
title FUSE Security Scanner - Docker Deployment

cls
echo.
echo ╔════════════════════════════════════════════════╗
echo ║   FUSE Security Scanner - Docker Execution   ║
echo ╚════════════════════════════════════════════════╝
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    color 0C
    echo.
    echo ❌ ERROR: Docker is not installed or not in PATH
    echo.
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo ✓ Docker detected
docker --version

REM Check if Docker daemon is running
docker ps >nul 2>&1
if errorlevel 1 (
    color 0C
    echo.
    echo ❌ ERROR: Docker daemon is not running
    echo.
    echo Please start Docker Desktop
    pause
    exit /b 1
)

echo ✓ Docker daemon is running
echo.

REM Build and start containers
echo 🔨 Building and starting containers...
echo.

docker-compose up -d

REM Wait for services to be ready
echo.
echo ⏳ Waiting for services to start (10 seconds)...
timeout /t 10 /nobreak

REM Check if containers are running
docker ps | findstr cyber-pentest >nul 2>&1
if errorlevel 1 (
    color 0C
    echo.
    echo ⚠️  Warning: Some containers may not be running yet
    echo Use: docker-compose logs
    echo.
) else (
    color 02
    echo.
    echo ✓ All services started successfully!
    echo.
)

REM Display access information
color 0A
echo.
echo ╔════════════════════════════════════════════════╗
echo ║           Access Information                 ║
echo ╚════════════════════════════════════════════════╝
echo.
echo 🌐 Frontend (Web Interface)
echo    → http://localhost
echo.
echo 🔌 API Server
echo    → http://localhost:8000
echo.
echo 📖 API Documentation (Swagger)
echo    → http://localhost:8000/docs
echo.
echo ❤️  Health Check
echo    → http://localhost:8000/health
echo.
echo 🗄️  MySQL Database
echo    → localhost:3306 (internal)
echo.
echo 🔴 Redis Cache
echo    → localhost:6379 (internal)
echo.
echo ═══════════════════════════════════════════════════════
echo.
echo 📋 Useful Docker Commands:
echo.
echo View logs:        docker-compose logs -f
echo Stop containers:  docker-compose down
echo Restart services: docker-compose restart
echo Run shell:        docker-compose exec api bash
echo.
echo ═══════════════════════════════════════════════════════
echo.

pause
