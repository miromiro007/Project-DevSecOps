# 🐳 Guide d'Exécution avec Docker

## ⚡ Démarrage Rapide

### Windows
```bash
docker-run.bat
```

### Linux / macOS
```bash
chmod +x docker-run.sh
./docker-run.sh
```

---

## 📋 Prérequis

- **Docker Desktop** installé et en cours d'exécution
- **Docker Compose** (inclus avec Docker Desktop)
- **Ports disponibles**: 80, 8000, 3306, 6379

### Vérifier l'installation
```bash
docker --version
docker-compose --version
docker ps
```

---

## 🌐 Accès aux Services

Une fois lancé, voici les URLs disponibles:

### Interface Web (Frontend)
```
http://localhost
```
- Interface de scan pentesting
- Visualisation en temps réel
- Rapports AI générés
- Console de logs en direct

### API Backend
```
http://localhost:8000
```
- Endpoint de scan: `POST /scan`
- Endpoint de statut: `GET /status/{scan_id}`
- Health check: `GET /health`

### Documentation API (Swagger UI)
```
http://localhost:8000/docs
```
- Interactive API documentation
- Testez les endpoints directement

### Health Check
```
http://localhost:8000/health
```
- Vérifiez que l'API est opérationnelle

---

## 🛠️ Commandes Utiles

### Afficher les logs en temps réel
```bash
docker-compose logs -f
docker-compose logs -f api          # Logs de l'API
docker-compose logs -f web          # Logs du frontend
docker-compose logs -f db           # Logs de la base de données
```

### Arrêter les conteneurs
```bash
docker-compose down
```

### Redémarrer les services
```bash
docker-compose restart
```

### Accéder au shell du conteneur API
```bash
docker-compose exec api bash
```

### Accéder à la base de données MySQL
```bash
docker-compose exec db mysql -u root -p
# Password: your_root_password (see docker-compose.yml)
```

### Supprimer tous les conteneurs (reset complet)
```bash
docker-compose down -v
```

### Voir l'état des conteneurs
```bash
docker-compose ps
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│    Internet / Local Network             │
└──────────────────┬──────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
    Port 80                Port 8000
   (Nginx)                  (API)
        │                     │
┌───────▼──────────┐  ┌──────▼──────────┐
│ Nginx Container  │  │ FastAPI App     │
│ (Frontend)       │  │ (Backend API)   │
└──────────────────┘  └──────┬──────────┘
                              │
                    ┌─────────┴──────────┐
                    │                    │
              Port 3306             Port 6379
            (MySQL DB)            (Redis Cache)
                    │                    │
            ┌───────▼────────┐  ┌────────▼────────┐
            │ MySQL 8.0      │  │ Redis 7         │
            │ Database       │  │ Cache Layer     │
            └────────────────┘  └─────────────────┘
```

---

## 🔧 Configuration

### Variables d'environnement (docker-compose.yml)

**API Service:**
```
GEMINI_API_KEY=your_api_key_here
SCAN_TIMEOUT=300
MAX_PORTS=1000
```

**MySQL Database:**
```
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_DATABASE=cybersecurity
MYSQL_USER=pentest
MYSQL_PASSWORD=pentest_pass
```

**Redis:**
```
Pas de configuration requise (fonctionnement par défaut)
```

---

## ✅ Checklist de Démarrage

- [ ] Docker Desktop est installé et en cours d'exécution
- [ ] Tous les ports (80, 8000, 3306, 6379) sont disponibles
- [ ] Script de lancement est exécutable
- [ ] Conteneurs sont lancés (`docker-compose up -d`)
- [ ] Attendre 10-15 secondes pour que tout démarre
- [ ] Vérifier http://localhost dans le navigateur
- [ ] Vérifier http://localhost:8000/health en cas de problème

---

## 🐛 Dépannage

### Les conteneurs ne démarrent pas

**Vérifiez les logs:**
```bash
docker-compose logs
```

**Vérifiez les ports utilisés:**
```bash
# Windows
netstat -ano | findstr :80
netstat -ano | findstr :8000

# Linux/macOS
lsof -i :80
lsof -i :8000
```

### L'API ne répond pas

1. Vérifier si le conteneur API s'exécute:
```bash
docker-compose ps
```

2. Vérifier les logs de l'API:
```bash
docker-compose logs api
```

3. Tester l'endpoint health:
```bash
curl http://localhost:8000/health
```

### Erreur de connexion à la base de données

```bash
# Vérifier la connexion MySQL
docker-compose exec db mysql -u root -p -e "SHOW DATABASES;"

# Vérifier les variables d'environnement
docker-compose exec api env | grep MYSQL
```

### Réinitialiser complètement

```bash
# Arrêter et supprimer tous les conteneurs et volumes
docker-compose down -v

# Supprimer les images (optionnel)
docker-compose down -v --rmi all

# Relancer
docker-compose up -d
```

---

## 📊 Monitoring

### Stats des conteneurs
```bash
docker stats
```

### Utilisation des ressources
```bash
docker-compose ps -q | xargs docker stats
```

### Vérifier la santé des services
```bash
# API Health
curl http://localhost:8000/health

# Frontend
curl http://localhost -I
```

---

## 🔒 Considérations de Sécurité

1. **Changez les mots de passe par défaut** dans `docker-compose.yml`
2. **Ne mettez jamais votre GEMINI_API_KEY en dur** - utiliser des variables d'environnement
3. **En production**, utilisez HTTPS et un reverse proxy sécurisé
4. **Limitez l'accès réseau** aux ports nécessaires uniquement

---

## 📝 Fichiers Importants

- `docker-compose.yml` - Orchestration des conteneurs
- `Dockerfile` - Configuration de l'image API
- `nginx.conf` - Configuration du reverse proxy
- `main.py` - Application FastAPI
- `requirements.txt` - Dépendances Python

---

## 🚀 Prochaines Étapes

1. **Configurez vos API Keys:**
   - Gemini API key pour les rapports AI
   - Nmap dans le conteneur API

2. **Customisez les paramètres:**
   - Timeouts de scan
   - Limites de ports
   - Paramètres de cache

3. **Configurez la persistance:**
   - Volume MySQL pour les données
   - Volume Redis pour le cache

4. **Mettez en place le monitoring:**
   - Prometheus metrics
   - Loki logs

---

**Besoin d'aide?** Vérifiez les fichiers `DOCUMENTATION.md` et `README.md` pour plus de détails.
