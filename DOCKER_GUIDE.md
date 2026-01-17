# 🐳 Guide Docker - FUSE Security Scanner

## 🚀 Démarrage Rapide

### Option 1 : Avec Script Automatique (Recommandé)

**Windows :**
```bash
rebuild.bat
```

**Linux/Mac :**
```bash
chmod +x rebuild.sh
./rebuild.sh
```

### Option 2 : Commandes Docker Directes

```bash
# Rebuild complet
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Rebuild rapide
docker-compose build
docker-compose up -d --force-recreate
```

---

## 📋 Options du Script rebuild

Le script `rebuild.bat` (Windows) ou `rebuild.sh` (Linux/Mac) propose 5 options :

### 1️⃣ Rebuild Complet
```
- Arrête tous les conteneurs
- Supprime les anciennes images
- Reconstruit tout depuis zéro (--no-cache)
- Démarre les nouveaux conteneurs
- Durée : ~2-5 minutes
```
**Quand l'utiliser :** Après modification du Dockerfile, requirements.txt, ou problèmes persistants

### 2️⃣ Rebuild Rapide
```
- Reconstruit les images (avec cache)
- Recrée les conteneurs
- Durée : ~30 secondes - 1 minute
```
**Quand l'utiliser :** Après modification du code Python ou du frontend

### 3️⃣ Redémarrer
```
- Redémarre les conteneurs existants
- Ne reconstruit rien
- Durée : ~10-20 secondes
```
**Quand l'utiliser :** Après modification de .env ou configuration simple

### 4️⃣ Voir les Logs
```
- Affiche les logs en temps réel
- Utile pour débugger
- Ctrl+C pour quitter
```
**Quand l'utiliser :** Pour surveiller l'activité ou débugger des erreurs

### 5️⃣ Arrêter
```
- Arrête tous les conteneurs
- Libère les ports
```
**Quand l'utiliser :** Quand vous avez terminé ou voulez libérer des ressources

---

## 🏗️ Architecture des Conteneurs

### Services Déployés

```
┌─────────────────────────────────────────────┐
│  Nginx (Frontend)                           │
│  Port: 80, 443                              │
│  Sert les fichiers static/                 │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│  FastAPI (Backend)                          │
│  Port: 8000                                 │
│  Application Python + Nmap                  │
└──────────────┬──────────────────────────────┘
               │
     ┌─────────┴─────────┐
     │                   │
┌────▼─────┐      ┌─────▼──────┐
│  MySQL   │      │   Redis    │
│  Port:   │      │   Port:    │
│  3306    │      │   6379     │
└──────────┘      └────────────┘
```

### Conteneurs

1. **cyber-pentest-frontend** (Nginx)
   - Sert l'interface web moderne
   - Reverse proxy vers l'API
   - Ports : 80, 443

2. **cyber-pentest-api** (FastAPI + Python)
   - API REST
   - Workflows de pentesting
   - Port : 8000

3. **cyber-pentest-db** (MySQL)
   - Base de données
   - Stockage des résultats
   - Port : 3306

4. **cyber-pentest-redis** (Redis)
   - Cache
   - Queue (optionnel)
   - Port : 6379

---

## 🌐 URLs Disponibles

Après le démarrage des conteneurs :

```
✅ Frontend Web       : http://localhost
✅ API Backend        : http://localhost:8000
✅ API Documentation  : http://localhost:8000/docs
✅ Health Check       : http://localhost:8000/health
✅ Base de données    : localhost:3306
✅ Redis              : localhost:6379
```

---

## 📝 Commandes Docker Utiles

### Gestion des Conteneurs

```bash
# Voir l'état de tous les conteneurs
docker-compose ps

# Démarrer les conteneurs
docker-compose up -d

# Arrêter les conteneurs
docker-compose down

# Redémarrer un service spécifique
docker-compose restart api

# Redémarrer tous les services
docker-compose restart
```

### Logs et Débogage

```bash
# Voir tous les logs
docker-compose logs

# Voir les logs en temps réel
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f api

# Dernières 50 lignes de logs
docker-compose logs --tail=50
```

### Accès Shell

```bash
# Shell dans le conteneur API
docker-compose exec api bash

# Shell dans le conteneur DB
docker-compose exec db bash

# MySQL CLI
docker-compose exec db mysql -u root -p
# Mot de passe : 12345

# Redis CLI
docker-compose exec redis redis-cli -a redis_secure_password
```

### Rebuild et Nettoyage

```bash
# Rebuild un service spécifique
docker-compose build api

# Rebuild tout
docker-compose build

# Rebuild sans cache
docker-compose build --no-cache

# Supprimer les conteneurs et volumes
docker-compose down -v

# Nettoyer tout (images, conteneurs, volumes)
docker system prune -a --volumes
```

### Vérification

```bash
# Health check manuel
docker-compose exec api curl http://localhost:8000/health

# Tester la connexion DB
docker-compose exec api python -c "from utils.db import engine; print(engine.connect())"

# Vérifier Nmap
docker-compose exec api nmap --version

# Vérifier les dépendances Python
docker-compose exec api pip list
```

---

## 🐛 Troubleshooting

### ❌ Problème : Port déjà utilisé

**Erreur :**
```
Error: Bind for 0.0.0.0:8000 failed: port is already allocated
```

**Solution :**
```bash
# Trouver le processus utilisant le port
netstat -ano | findstr :8000    # Windows
lsof -i :8000                   # Linux/Mac

# Arrêter l'ancien conteneur
docker-compose down

# Ou changer le port dans docker-compose.yml
ports:
  - "8001:8000"  # Utiliser 8001 au lieu de 8000
```

### ❌ Problème : Conteneur ne démarre pas

**Solution :**
```bash
# Voir les logs détaillés
docker-compose logs api

# Vérifier le health check
docker ps

# Reconstruire complètement
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### ❌ Problème : Base de données inaccessible

**Solution :**
```bash
# Vérifier que le conteneur DB est up
docker-compose ps db

# Vérifier les logs DB
docker-compose logs db

# Attendre que DB soit ready
docker-compose exec db mysqladmin ping -h localhost

# Recréer le volume si nécessaire
docker-compose down -v
docker-compose up -d
```

### ❌ Problème : Frontend ne se charge pas

**Solution :**
```bash
# Vérifier que les fichiers static existent
ls -la static/

# Rebuilder avec les fichiers static
docker-compose build api
docker-compose up -d

# Vérifier les permissions
docker-compose exec api ls -la /app/static/
```

### ❌ Problème : Import Error / Module Not Found

**Solution :**
```bash
# Vérifier les dépendances installées
docker-compose exec api pip list

# Rebuilder avec --no-cache
docker-compose build --no-cache api

# Vérifier requirements.txt
cat requirements.txt
```

---

## ⚙️ Configuration

### Variables d'Environnement

Créez un fichier `.env` à la racine :

```env
# API
ENVIRONMENT=production
GEMINI_API_KEY=votre_clé_api

# Database
DATABASE_URL=mysql+pymysql://root:12345@db:3306/pentest_db
MYSQL_ROOT_PASSWORD=12345
MYSQL_DATABASE=pentest_db

# Redis
REDIS_PASSWORD=redis_secure_password
```

### Personnaliser docker-compose.yml

```yaml
# Changer les ports
services:
  api:
    ports:
      - "8001:8000"  # Au lieu de 8000:8000

# Ajouter des volumes persistants
services:
  api:
    volumes:
      - ./logs:/app/logs
      - ./reports:/app/reports

# Limiter les ressources
services:
  api:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

---

## 🚀 Optimisations

### Accélérer le Build

```bash
# Utiliser BuildKit
export DOCKER_BUILDKIT=1    # Linux/Mac
set DOCKER_BUILDKIT=1       # Windows

docker-compose build

# Multi-stage build (déjà implémenté dans Dockerfile)
# Utiliser le cache Docker
docker-compose build --parallel
```

### Réduire la Taille de l'Image

```dockerfile
# Déjà optimisé dans le Dockerfile :
- Python slim (pas full)
- Nettoyage apt-get
- No-cache-dir pour pip
- Suppression des fichiers temporaires
```

### Améliorer la Sécurité

```bash
# Scan de vulnérabilités
docker scan cyber-pentest-api

# Utiliser un utilisateur non-root (déjà fait)
# Pas de nouveaux privilèges
docker-compose.yml:
  security_opt:
    - no-new-privileges:true
```

---

## 📊 Monitoring

### Voir l'Utilisation des Ressources

```bash
# CPU, RAM, Network de tous les conteneurs
docker stats

# D'un conteneur spécifique
docker stats cyber-pentest-api

# Espace disque
docker system df
```

### Health Checks

```bash
# Vérifier tous les health checks
docker ps --format "table {{.Names}}\t{{.Status}}"

# Health check manuel
curl http://localhost:8000/health
curl http://localhost/
```

---

## 🎯 Workflows Recommandés

### Développement

```bash
# 1. Modifier le code
# 2. Rebuild rapide
./rebuild.sh
# Choisir option 2

# 3. Voir les logs
docker-compose logs -f api
```

### Production

```bash
# 1. Rebuild complet
./rebuild.sh
# Choisir option 1

# 2. Vérifier les health checks
docker-compose ps

# 3. Tester l'API
curl http://localhost:8000/health

# 4. Monitorer
docker stats
```

### Mise à Jour

```bash
# 1. Sauvegarder la DB
docker-compose exec db mysqldump -u root -p12345 pentest_db > backup.sql

# 2. Arrêter
docker-compose down

# 3. Pull les nouvelles images
git pull
docker-compose pull

# 4. Rebuild
docker-compose build --no-cache

# 5. Démarrer
docker-compose up -d

# 6. Vérifier
docker-compose ps
docker-compose logs -f
```

---

## 📚 Ressources

### Documentation
- [Docker Docs](https://docs.docker.com/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [FastAPI in Docker](https://fastapi.tiangolo.com/deployment/docker/)

### Commandes de Référence
```bash
docker --help
docker-compose --help
docker ps --help
```

---

## 🎉 Résumé

### Pour Rebuilder Rapidement
```bash
# Windows
rebuild.bat

# Linux/Mac
./rebuild.sh
```

### Pour Débugger
```bash
docker-compose logs -f
```

### Pour Accéder au Conteneur
```bash
docker-compose exec api bash
```

### URLs
- Frontend: http://localhost
- API: http://localhost:8000
- Docs: http://localhost:8000/docs

---

**Vous êtes prêt à rebuilder ! 🐳🚀**
