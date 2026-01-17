#!/bin/bash

# =========================================
# Docker Containerization Launch Script
# =========================================

clear

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   FUSE Security Scanner - Docker Execution   ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed"
    echo ""
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    echo ""
    exit 1
fi

echo "✓ Docker detected"
docker --version

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo ""
    echo "❌ ERROR: Docker daemon is not running"
    echo ""
    echo "Please start Docker daemon: sudo systemctl start docker"
    echo ""
    exit 1
fi

echo "✓ Docker daemon is running"
echo ""

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  docker-compose not found, using 'docker compose' instead"
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo "🔨 Building and starting containers..."
echo ""

$DOCKER_COMPOSE up -d

# Wait for services to be ready
echo ""
echo "⏳ Waiting for services to start (10 seconds)..."
sleep 10

# Check if containers are running
if ! docker ps | grep -q cyber-pentest; then
    echo ""
    echo "⚠️  Warning: Some containers may not be running yet"
    echo "Run: $DOCKER_COMPOSE logs"
    echo ""
else
    echo ""
    echo "✓ All services started successfully!"
    echo ""
fi

# Display access information
echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║           Access Information                 ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "🌐 Frontend (Web Interface)"
echo "   → http://localhost"
echo ""
echo "🔌 API Server"
echo "   → http://localhost:8000"
echo ""
echo "📖 API Documentation (Swagger)"
echo "   → http://localhost:8000/docs"
echo ""
echo "❤️  Health Check"
echo "   → http://localhost:8000/health"
echo ""
echo "🗄️  MySQL Database"
echo "   → localhost:3306 (internal)"
echo ""
echo "🔴 Redis Cache"
echo "   → localhost:6379 (internal)"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
echo "📋 Useful Docker Commands:"
echo ""
echo "View logs:        $DOCKER_COMPOSE logs -f"
echo "Stop containers:  $DOCKER_COMPOSE down"
echo "Restart services: $DOCKER_COMPOSE restart"
echo "Run shell:        $DOCKER_COMPOSE exec api bash"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
