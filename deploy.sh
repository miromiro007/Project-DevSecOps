#!/bin/bash

# ============================================================================
# Cyber-Pentest - Script de Déploiement
# ============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# FONCTIONS UTILITAIRES
# ============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ============================================================================
# VÉRIFICATIONS PRÉALABLES
# ============================================================================

check_prerequisites() {
    print_header "VÉRIFICATION DES PRÉREQUIS"

    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker n'est pas installé"
        echo "Installer depuis: https://docs.docker.com/get-docker/"
        exit 1
    fi
    print_success "Docker trouvé: $(docker --version)"

    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose n'est pas installé"
        exit 1
    fi
    print_success "Docker Compose trouvé: $(docker-compose --version)"

    # Vérifier Git
    if ! command -v git &> /dev/null; then
        print_warning "Git n'est pas installé (optionnel)"
    else
        print_success "Git trouvé: $(git --version)"
    fi

    # Vérifier l'espace disque
    available_space=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
    if [ "$available_space" -lt 20 ]; then
        print_error "Espace disque insuffisant: ${available_space}GB (minimum 20GB)"
        exit 1
    fi
    print_success "Espace disque: ${available_space}GB disponible"
}

# ============================================================================
# CONFIGURATION
# ============================================================================

configure_environment() {
    print_header "CONFIGURATION DE L'ENVIRONNEMENT"

    if [ ! -f .env ]; then
        print_info "Création du fichier .env..."
        cp .env.example .env
        print_success "Fichier .env créé"

        print_warning "⚠️  IMPORTANT: Configurez .env avec vos paramètres"
        print_warning "Notamment: GEMINI_API_KEY"
        echo ""
        read -p "Appuyez sur Entrée une fois .env configuré..."
    else
        print_success "Fichier .env déjà existant"
    fi
}

# ============================================================================
# DÉMARRAGE DES SERVICES
# ============================================================================

start_services() {
    print_header "DÉMARRAGE DES SERVICES"

    print_info "Tirage des images Docker..."
    docker-compose pull

    print_info "Démarrage des services..."
    docker-compose up -d

    print_info "Attente de la stabilisation des services..."
    sleep 10

    # Vérifier l'état
    print_info "Vérification de l'état des services..."
    if docker-compose ps | grep -q "healthy"; then
        print_success "Services en cours d'exécution"
    else
        print_warning "Certains services ne sont pas encore prêts, patientez..."
        sleep 10
    fi
}

# ============================================================================
# INITIALISATION BD
# ============================================================================

init_database() {
    print_header "INITIALISATION DE LA BASE DE DONNÉES"

    print_info "Attente de la disponibilité de PostgreSQL..."
    for i in {1..30}; do
        if docker-compose exec -T db pg_isready -U pentest &> /dev/null; then
            print_success "PostgreSQL disponible"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "PostgreSQL n'a pas démarré à temps"
            exit 1
        fi
        sleep 1
    done

    print_info "Création des tables..."
    docker-compose exec -T api python -c "
from utils.db import Base, engine
Base.metadata.create_all(bind=engine)
print('✅ Tables créées')
" || print_warning "Les tables ont peut-être déjà été créées"
}

# ============================================================================
# AFFICHAGE DES INFORMATIONS
# ============================================================================

display_info() {
    print_header "🎉 INSTALLATION COMPLÉTÉE"

    echo -e "${GREEN}Services disponibles:${NC}"
    echo ""
    echo "  Frontend:     ${BLUE}http://localhost${NC}"
    echo "  API:          ${BLUE}http://localhost:8000${NC}"
    echo "  API Docs:     ${BLUE}http://localhost:8000/docs${NC}"
    echo "  Grafana:      ${BLUE}http://localhost:3000${NC} (admin/admin)"
    echo "  Prometheus:   ${BLUE}http://localhost:9090${NC}"
    echo ""

    echo -e "${GREEN}Commandes utiles:${NC}"
    echo ""
    echo "  Voir les logs:       ${BLUE}docker-compose logs -f api${NC}"
    echo "  Arrêter:             ${BLUE}docker-compose stop${NC}"
    echo "  Redémarrer:          ${BLUE}docker-compose restart${NC}"
    echo "  Arrêter (purger):    ${BLUE}docker-compose down -v${NC}"
    echo ""

    echo -e "${YELLOW}⚠️  RAPPEL LÉGAL:${NC}"
    echo "  ✅ Tester uniquement les systèmes AUTORISÉS"
    echo "  ✅ Respecter les lois locales"
    echo "  ❌ Ne pas attaquer sans permission écrite"
    echo ""
}

# ============================================================================
# TESTS RAPIDES
# ============================================================================

run_tests() {
    print_header "TESTS RAPIDES"

    print_info "Test API health..."
    if curl -s http://localhost:8000/health | grep -q "healthy"; then
        print_success "API répond correctement"
    else
        print_warning "API en démarrage..."
    fi

    print_info "Test Frontend..."
    if curl -s http://localhost | grep -q "Cyber-Pentest"; then
        print_success "Frontend accessible"
    else
        print_warning "Frontend en démarrage..."
    fi

    print_info "Test Base de Données..."
    if docker-compose exec -T db psql -U pentest -d pentest_db -c "SELECT 1;" &> /dev/null; then
        print_success "Base de données opérationnelle"
    else
        print_warning "Base de données en initialisation..."
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    clear

    print_header "🛡️  CYBER-PENTEST - INSTALLATION AUTOMATIQUE"

    check_prerequisites
    configure_environment
    start_services
    init_database
    run_tests
    display_info

    print_success "Installation terminée avec succès!"
    echo ""
    echo "Pour lancer votre premier scan: http://localhost"
    echo ""
}

# Exécuter
main "$@"
