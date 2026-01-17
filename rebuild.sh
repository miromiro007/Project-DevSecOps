#!/bin/bash

echo "========================================"
echo " FUSE Security Scanner - Docker Rebuild"
echo "========================================"
echo ""

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "[ERREUR] Docker n'est pas installé"
    echo "Installez Docker : https://docs.docker.com/get-docker/"
    exit 1
fi

echo "[OK] Docker détecté"
echo ""

# Demander le mode
echo "Choisissez une option :"
echo "1. Rebuild complet (arrêt, suppression, reconstruction)"
echo "2. Rebuild rapide (reconstruction seulement)"
echo "3. Redémarrer les conteneurs existants"
echo "4. Voir les logs"
echo "5. Arrêter tous les conteneurs"
echo ""
read -p "Votre choix (1-5) : " choice

case $choice in
    1)
        echo ""
        echo "========================================"
        echo " Rebuild Complet"
        echo "========================================"
        echo ""
        
        echo "[1/5] Arrêt des conteneurs..."
        docker-compose down
        
        echo ""
        echo "[2/5] Suppression des images..."
        docker-compose rm -f
        
        echo ""
        echo "[3/5] Reconstruction des images..."
        docker-compose build --no-cache
        
        echo ""
        echo "[4/5] Démarrage des conteneurs..."
        docker-compose up -d
        
        echo ""
        echo "[5/5] Vérification de l'état..."
        sleep 5
        docker-compose ps
        
        echo ""
        echo "========================================"
        echo " ✅ Rebuild Complet Terminé !"
        echo "========================================"
        ;;
        
    2)
        echo ""
        echo "========================================"
        echo " Rebuild Rapide"
        echo "========================================"
        echo ""
        
        echo "[1/3] Reconstruction des images..."
        docker-compose build
        
        echo ""
        echo "[2/3] Redémarrage des conteneurs..."
        docker-compose up -d --force-recreate
        
        echo ""
        echo "[3/3] Vérification de l'état..."
        sleep 5
        docker-compose ps
        
        echo ""
        echo "========================================"
        echo " ✅ Rebuild Rapide Terminé !"
        echo "========================================"
        ;;
        
    3)
        echo ""
        echo "========================================"
        echo " Redémarrage des Conteneurs"
        echo "========================================"
        echo ""
        
        docker-compose restart
        
        sleep 3
        docker-compose ps
        
        echo ""
        echo "========================================"
        echo " ✅ Conteneurs Redémarrés !"
        echo "========================================"
        ;;
        
    4)
        echo ""
        echo "========================================"
        echo " Logs des Conteneurs"
        echo "========================================"
        echo ""
        echo "Appuyez sur Ctrl+C pour quitter"
        echo ""
        docker-compose logs -f --tail=50
        exit 0
        ;;
        
    5)
        echo ""
        echo "========================================"
        echo " Arrêt des Conteneurs"
        echo "========================================"
        echo ""
        docker-compose down
        echo ""
        echo "✅ Tous les conteneurs sont arrêtés"
        exit 0
        ;;
        
    *)
        echo ""
        echo "[ERREUR] Choix invalide. Veuillez choisir entre 1 et 5."
        exit 1
        ;;
esac

# Afficher les informations
echo ""
echo "🌐 URLs Disponibles :"
echo "   - Frontend : http://localhost"
echo "   - API      : http://localhost:8000"
echo "   - API Docs : http://localhost:8000/docs"
echo "   - Health   : http://localhost:8000/health"
echo ""
echo "📊 État des Services :"
docker-compose ps
echo ""
echo "💡 Commandes Utiles :"
echo "   - Voir les logs    : docker-compose logs -f"
echo "   - Arrêter          : docker-compose down"
echo "   - Redémarrer       : docker-compose restart"
echo "   - Shell API        : docker-compose exec api bash"
echo "   - Shell DB         : docker-compose exec db mysql -u root -p"
echo ""
