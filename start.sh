#!/bin/bash

echo "========================================"
echo " FUSE Security Scanner - Launcher"
echo "========================================"
echo ""

# Vérifier Python
if ! command -v python3 &> /dev/null; then
    echo "[ERREUR] Python3 n'est pas installé"
    exit 1
fi

echo "[OK] Python3 détecté"
echo ""

# Vérifier les dépendances
echo "Vérification des dépendances..."
python3 -c "import fastapi" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "[INFO] Installation des dépendances nécessaires..."
    pip3 install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "[ERREUR] Échec de l'installation des dépendances"
        exit 1
    fi
else
    echo "[OK] Dépendances installées"
fi

echo ""
echo "========================================"
echo " Démarrage du serveur..."
echo "========================================"
echo ""
echo "Frontend disponible sur : http://localhost:8000"
echo "API Documentation       : http://localhost:8000/docs"
echo "Preview                 : http://localhost:8000/static/preview.html"
echo ""
echo "Appuyez sur CTRL+C pour arrêter le serveur"
echo "========================================"
echo ""

# Démarrer le serveur
python3 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
