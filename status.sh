#!/bin/bash

# Cyber-Pentest - Health Check & Status

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}      Cyber-Pentest - Status & Health Check           ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Fonction pour tester un service
test_service() {
    local name=$1
    local url=$2
    local expected=$3

    echo -n "Testing $name... "
    
    if response=$(curl -s -m 5 "$url" 2>/dev/null); then
        if [[ -z "$expected" ]] || echo "$response" | grep -q "$expected"; then
            echo -e "${GREEN}✅ OK${NC}"
            return 0
        else
            echo -e "${YELLOW}⚠️  Unexpected response${NC}"
            return 1
        fi
    else
        echo -e "${RED}❌ Failed${NC}"
        return 1
    fi
}

echo -e "${BLUE}Docker Containers:${NC}"
echo ""

# Vérifier Docker
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose not found${NC}"
    exit 1
fi

# Afficher l'état
docker-compose ps

echo ""
echo -e "${BLUE}API Health Checks:${NC}"
echo ""

# Tests de santé
test_service "Frontend" "http://localhost" "Cyber-Pentest"
test_service "API Health" "http://localhost:8000/health" "healthy"
test_service "API Docs" "http://localhost:8000/docs" "swagger"

echo ""
echo -e "${BLUE}Services Status:${NC}"
echo ""

# Vérifier la DB
echo -n "PostgreSQL... "
if docker-compose exec -T db pg_isready -U pentest &> /dev/null; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${YELLOW}⚠️  Not ready${NC}"
fi

# Vérifier Redis
echo -n "Redis... "
if docker-compose exec -T redis redis-cli ping &> /dev/null | grep -q "PONG"; then
    echo -e "${GREEN}✅ Running${NC}"
else
    echo -e "${YELLOW}⚠️  Not responding${NC}"
fi

echo ""
echo -e "${BLUE}Available URLs:${NC}"
echo ""
echo -e "  Frontend:     ${GREEN}http://localhost${NC}"
echo -e "  API:          ${GREEN}http://localhost:8000${NC}"
echo -e "  API Docs:     ${GREEN}http://localhost:8000/docs${NC}"
echo -e "  Grafana:      ${GREEN}http://localhost:3000${NC} (admin/admin)"
echo -e "  Prometheus:   ${GREEN}http://localhost:9090${NC}"
echo ""

echo -e "${BLUE}Quick Commands:${NC}"
echo ""
echo "  View logs:     docker-compose logs -f api"
echo "  Stop:          docker-compose stop"
echo "  Restart:       docker-compose restart"
echo "  Full cleanup:  docker-compose down -v"
echo ""
