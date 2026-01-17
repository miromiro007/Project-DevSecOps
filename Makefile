.PHONY: help up down logs restart build clean test health shell lint format docs

# Couleurs
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m

help:
	@echo "$(BLUE)╔════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║$(NC)      Cyber-Pentest - Makefile Helper Commands           $(BLUE)║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Installation:$(NC)"
	@echo "  make install         Installer et démarrer"
	@echo "  make build           Builder les images Docker"
	@echo ""
	@echo "$(GREEN)Services:$(NC)"
	@echo "  make up              Démarrer tous les services"
	@echo "  make down            Arrêter tous les services"
	@echo "  make restart         Redémarrer les services"
	@echo "  make logs            Voir les logs en temps réel"
	@echo "  make health          Vérifier la santé de l'API"
	@echo ""
	@echo "$(GREEN)Développement:$(NC)"
	@echo "  make shell           Shell interactive dans l'API"
	@echo "  make test            Lancer les tests"
	@echo "  make lint            Vérifier la syntaxe"
	@echo "  make format          Formater le code"
	@echo ""
	@echo "$(GREEN)Base de données:$(NC)"
	@echo "  make db-shell        Accès PostgreSQL shell"
	@echo "  make db-reset        Réinitialiser la base"
	@echo ""
	@echo "$(GREEN)Nettoyage:$(NC)"
	@echo "  make clean           Arrêter et purger tout"
	@echo "  make clean-volumes   Supprimer les données persistantes"
	@echo ""
	@echo "$(GREEN)Documentation:$(NC)"
	@echo "  make docs            Ouvrir la documentation"
	@echo ""

install: .env up
	@echo "$(GREEN)✅ Installation complétée$(NC)"
	@echo "Accédez à http://localhost"

.env:
	@echo "$(GREEN)Création de .env...$(NC)"
	@cp .env.example .env
	@echo "$(RED)⚠️  Editez .env et configurez vos clés API$(NC)"

build:
	@echo "$(GREEN)Construction des images Docker...$(NC)"
	docker-compose build

up:
	@echo "$(GREEN)Démarrage des services...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✅ Services en ligne$(NC)"
	@echo "Frontend: http://localhost"
	@echo "API: http://localhost:8000"

down:
	@echo "$(RED)Arrêt des services...$(NC)"
	docker-compose down

restart:
	@echo "$(BLUE)Redémarrage des services...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✅ Services redémarrés$(NC)"

logs:
	docker-compose logs -f api

logs-all:
	docker-compose logs -f

health:
	@echo "$(BLUE)Vérification de la santé de l'API...$(NC)"
	@curl -s http://localhost:8000/health | jq . || echo "API non répondante"

shell:
	@echo "$(BLUE)Ouverture du shell API...$(NC)"
	docker-compose exec api /bin/bash

db-shell:
	@echo "$(BLUE)Ouverture de PostgreSQL...$(NC)"
	docker-compose exec db psql -U pentest -d pentest_db

db-reset:
	@echo "$(RED)⚠️  Réinitialisation de la base de données...$(NC)"
	docker-compose down db
	docker volume rm cyber-pentest_postgres_data || true
	docker-compose up -d db
	@echo "$(GREEN)✅ Base de données réinitialisée$(NC)"

test:
	@echo "$(BLUE)Lancement des tests...$(NC)"
	docker-compose exec api pytest tests/ -v

lint:
	@echo "$(BLUE)Vérification syntaxe Python...$(NC)"
	docker-compose exec api pylint workflow/*.py main.py models.py

format:
	@echo "$(BLUE)Formatage du code...$(NC)"
	docker-compose exec api black workflow/ main.py models.py

clean:
	@echo "$(RED)Nettoyage complet (arrêt + suppression)...$(NC)"
	docker-compose down
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Nettoyage terminé$(NC)"

clean-volumes:
	@echo "$(RED)Suppression des volumes persistants...$(NC)"
	docker-compose down -v
	@echo "$(GREEN)✅ Volumes supprimés$(NC)"

docs:
	@echo "$(BLUE)Ouverture de la documentation...$(NC)"
	@command -v xdg-open >/dev/null 2>&1 && xdg-open DOCUMENTATION.md || \
	command -v open >/dev/null 2>&1 && open DOCUMENTATION.md || \
	echo "DOCUMENTATION.md"

status:
	@echo "$(BLUE)État des services:$(NC)"
	docker-compose ps

# Alias
ps: status
start: up
stop: down
reload: restart
logs-api: logs
check: health

# Détection du système
ifeq ($(OS),Windows_NT)
    SHELL := cmd
endif

.DEFAULT_GOAL := help
