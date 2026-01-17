@echo off
REM ============================================================================
REM Cyber-Pentest - Script de Déploiement (Windows)
REM ============================================================================

setlocal enabledelayedexpansion

REM Couleurs
set "GREEN=[32m"
set "RED=[31m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "NC=[0m"

echo.
echo ==============================================================
echo         Cyber-Pentest - Installation Automatique
echo ==============================================================
echo.

REM Vérifier Docker
echo Vérification de Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%Erreur: Docker n'est pas installé%NC%
    echo Télécharger depuis: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo %GREEN%✓ Docker détecté%NC%

REM Vérifier Docker Compose
echo Vérification de Docker Compose...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%Erreur: Docker Compose n'est pas installé%NC%
    pause
    exit /b 1
)
echo %GREEN%✓ Docker Compose détecté%NC%

REM Créer .env si absent
if not exist .env (
    echo.
    echo Création du fichier .env...
    copy .env.example .env
    echo %GREEN%✓ Fichier .env créé%NC%
    echo.
    echo IMPORTANT: Éditez .env et configurez:
    echo   - GEMINI_API_KEY
    echo   - Autres paramètres si nécessaire
    echo.
    pause
)

REM Démarrer les services
echo.
echo Démarrage des services Docker...
docker-compose up -d

REM Attendre un peu
echo Attente de la stabilisation des services...
timeout /t 10 /nobreak

REM Vérifier l'état
echo.
echo État des services:
docker-compose ps

echo.
echo ==============================================================
echo                   Installation Complétée!
echo ==============================================================
echo.
echo Services disponibles:
echo   Frontend:     http://localhost
echo   API:          http://localhost:8000
echo   API Docs:     http://localhost:8000/docs
echo   Grafana:      http://localhost:3000 (admin/admin)
echo   Prometheus:   http://localhost:9090
echo.
echo Commandes utiles:
echo   Voir les logs:    docker-compose logs -f api
echo   Arrêter:         docker-compose stop
echo   Redémarrer:      docker-compose restart
echo   Arrêter (purge): docker-compose down -v
echo.
echo Ouvrez http://localhost dans votre navigateur!
echo.

pause
