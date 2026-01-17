@echo off
echo ========================================
echo  FUSE Security Scanner - Launcher
echo ========================================
echo.

REM Vérifier Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Python n'est pas installé ou pas dans le PATH
    echo Téléchargez Python depuis https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Python détecté
echo.

REM Vérifier les dépendances
echo Vérification des dépendances...
python -c "import fastapi" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installation des dépendances nécessaires...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERREUR] Échec de l'installation des dépendances
        pause
        exit /b 1
    )
) else (
    echo [OK] Dépendances installées
)

echo.
echo ========================================
echo  Démarrage du serveur...
echo ========================================
echo.
echo Frontend disponible sur : http://localhost:8000
echo API Documentation       : http://localhost:8000/docs
echo Preview                 : http://localhost:8000/static/preview.html
echo.
echo Appuyez sur CTRL+C pour arrêter le serveur
echo ========================================
echo.

REM Démarrer le serveur
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause
