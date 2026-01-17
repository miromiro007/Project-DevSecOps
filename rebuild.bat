@echo off
echo ========================================
echo  FUSE Security Scanner - Docker Rebuild
echo ========================================
echo.

REM Vérifier que Docker est installé
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Docker n'est pas installé ou pas dans le PATH
    echo Installez Docker Desktop : https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo [OK] Docker détecté
echo.

REM Demander le mode
echo Choisissez une option :
echo 1. Rebuild complet (arrêt, suppression, reconstruction)
echo 2. Rebuild rapide (reconstruction seulement)
echo 3. Redémarrer les conteneurs existants
echo 4. Voir les logs
echo 5. Arrêter tous les conteneurs
echo.
set /p choice="Votre choix (1-5) : "

if "%choice%"=="1" goto rebuild_full
if "%choice%"=="2" goto rebuild_quick
if "%choice%"=="3" goto restart
if "%choice%"=="4" goto logs
if "%choice%"=="5" goto stop
goto invalid

:rebuild_full
echo.
echo ========================================
echo  Rebuild Complet
echo ========================================
echo.
echo [1/5] Arrêt des conteneurs...
docker-compose down

echo.
echo [2/5] Suppression des images...
docker-compose rm -f

echo.
echo [3/5] Reconstruction des images...
docker-compose build --no-cache

echo.
echo [4/5] Démarrage des conteneurs...
docker-compose up -d

echo.
echo [5/5] Vérification de l'état...
timeout /t 5 /nobreak >nul
docker-compose ps

echo.
echo ========================================
echo  ✅ Rebuild Complet Terminé !
echo ========================================
goto show_info

:rebuild_quick
echo.
echo ========================================
echo  Rebuild Rapide
echo ========================================
echo.
echo [1/3] Reconstruction des images...
docker-compose build

echo.
echo [2/3] Redémarrage des conteneurs...
docker-compose up -d --force-recreate

echo.
echo [3/3] Vérification de l'état...
timeout /t 5 /nobreak >nul
docker-compose ps

echo.
echo ========================================
echo  ✅ Rebuild Rapide Terminé !
echo ========================================
goto show_info

:restart
echo.
echo ========================================
echo  Redémarrage des Conteneurs
echo ========================================
echo.
docker-compose restart

timeout /t 3 /nobreak >nul
docker-compose ps

echo.
echo ========================================
echo  ✅ Conteneurs Redémarrés !
echo ========================================
goto show_info

:logs
echo.
echo ========================================
echo  Logs des Conteneurs
echo ========================================
echo.
echo Appuyez sur Ctrl+C pour quitter
echo.
docker-compose logs -f --tail=50
goto end

:stop
echo.
echo ========================================
echo  Arrêt des Conteneurs
echo ========================================
echo.
docker-compose down
echo.
echo ✅ Tous les conteneurs sont arrêtés
goto end

:invalid
echo.
echo [ERREUR] Choix invalide. Veuillez choisir entre 1 et 5.
pause
goto end

:show_info
echo.
echo 🌐 URLs Disponibles :
echo    - Frontend : http://localhost
echo    - API      : http://localhost:8000
echo    - API Docs : http://localhost:8000/docs
echo    - Health   : http://localhost:8000/health
echo.
echo 📊 État des Services :
docker-compose ps
echo.
echo 💡 Commandes Utiles :
echo    - Voir les logs    : docker-compose logs -f
echo    - Arrêter          : docker-compose down
echo    - Redémarrer       : docker-compose restart
echo    - Shell API        : docker-compose exec api bash
echo    - Shell DB         : docker-compose exec db mysql -u root -p
echo.

:end
pause
