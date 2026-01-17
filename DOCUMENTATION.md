# Cyber-Pentest - Documentation Complète

## 📋 Table des matières
1. [Introduction](#introduction)
2. [Architecture](#architecture)
3. [Installation](#installation)
4. [Usage](#usage)
5. [API Endpoints](#api-endpoints)
6. [Configuration](#configuration)
7. [Sécurité](#sécurité)
8. [Dépannage](#dépannage)

---

## 🎯 Introduction

**Cyber-Pentest** est une plateforme web d'orchestration de tests d'intrusion (Pentesting) permettant d'automatiser les principales étapes d'un pentest dans un cadre sécurisé, légal et pédagogique.

### Phases du Pentest Supportées
1. **Footprinting** - Reconnaissance passive et analyse d'en-têtes
2. **Scanning** - Détection de ports ouverts (Nmap)
3. **Exploitation** - Identification de vulnérabilités
4. **Post-Exploitation** - Analyse des privilèges
5. **Persistance** - Simulation de maintien d'accès
6. **Reporting** - Génération de rapports via IA (Gemini)

### Caractéristiques
- ✅ Interface web intuitive et responsive
- ✅ API RESTful FastAPI
- ✅ Conteneurisation complète (Docker)
- ✅ Base de données PostgreSQL
- ✅ Cache Redis pour optimisation
- ✅ Monitoring avec Prometheus/Grafana
- ✅ Logs centralisés avec Loki
- ✅ Rapports IA automatisés
- ✅ Multitenancy prêt

---

## 🏗️ Architecture

### Stack Technologique

```
┌─────────────────────────────────────────────────┐
│              Frontend (Nginx)                   │
│         HTML/CSS/JavaScript vanilla             │
└──────────────────┬──────────────────────────────┘
                   │
                   │ HTTP/WebSocket
                   │
┌──────────────────▼──────────────────────────────┐
│          Backend API (FastAPI)                  │
│  Orchestration des workflows de pentest        │
└──────────────┬──────────────────┬───────────────┘
               │                  │
    ┌──────────▼─────────┐   ┌────▼──────────┐
    │ PostgreSQL (DB)    │   │ Redis (Cache) │
    │ Scan Results       │   │ Sessions      │
    │ Vulnerability Data │   │ Rate Limiting │
    └────────────────────┘   └───────────────┘

Monitoring & Logging:
├── Prometheus (Métriques)
├── Loki (Logs centralisés)
└── Grafana (Dashboards)
```

### Services Docker
- **frontend**: Nginx (80, 443)
- **api**: FastAPI Backend (8000)
- **db**: PostgreSQL (5432)
- **redis**: Cache (6379)
- **loki**: Logs (3100)
- **prometheus**: Metrics (9090)
- **grafana**: Dashboards (3000)

---

## 📦 Installation

### Prérequis
- Docker & Docker Compose (v1.29+)
- Git
- 4GB RAM minimum
- 20GB espace disque

### Étapes d'Installation

#### 1. Cloner le repository
```bash
git clone https://github.com/your-repo/cyber-pentest.git
cd cyber-pentest
```

#### 2. Configurer les variables d'environnement
```bash
cp .env.example .env
# Éditer .env avec vos valeurs
nano .env
```

Valeurs importantes à configurer:
- `GEMINI_API_KEY`: Clé API Google Gemini pour IA
- `JWT_SECRET`: Clé secrète JWT
- `POSTGRES_PASSWORD`: Mot de passe BD
- `REDIS_PASSWORD`: Mot de passe Redis

#### 3. Démarrer les services
```bash
# Démarrer tous les services
docker-compose up -d

# Vérifier l'état
docker-compose ps

# Voir les logs
docker-compose logs -f api
```

#### 4. Initialiser la base de données
```bash
docker-compose exec api python -m alembic upgrade head
```

#### 5. Accéder à l'application
- **Frontend**: http://localhost
- **API**: http://localhost:8000
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090

---

## 🚀 Usage

### Via l'Interface Web

1. **Accéder à l'application**: http://localhost
2. **Entrer l'URL cible**: `https://httpbin.org` (exemple sûr)
3. **Cliquer sur "Lancer Scan"**
4. **Suivre la progression** en temps réel
5. **Télécharger le rapport** après completion

### Via cURL

#### Lancer un scan
```bash
curl -X POST http://localhost:8000/scan \
  -H "Content-Type: application/json" \
  -d '{
    "target_url": "https://httpbin.org"
  }'
```

Réponse:
```json
{
  "scan_id": "550e8400-e29b-41d4-a716-446655440000",
  "message": "Scan started"
}
```

#### Vérifier le statut
```bash
curl http://localhost:8000/status/550e8400-e29b-41d4-a716-446655440000
```

#### Health Check
```bash
curl http://localhost:8000/health
```

---

## 🔌 API Endpoints

### Scans

#### POST `/scan`
Lance un nouveau scan pentest

**Request:**
```json
{
  "target_url": "https://example.com"
}
```

**Response (200):**
```json
{
  "scan_id": "uuid",
  "message": "Scan started"
}
```

**Errors:**
- 400: URL invalide
- 429: Trop de scans concurrents
- 500: Erreur serveur

---

#### GET `/status/{scan_id}`
Récupère le statut d'un scan

**Response (200):**
```json
{
  "id": "uuid",
  "target_url": "https://example.com",
  "status": "running|pending|completed|failed",
  "step": 0-5,
  "logs": [
    "[12:30:45] Starting Footprinting...",
    "[12:30:47] Detected Server: Apache/2.4.49"
  ],
  "vulns": 3,
  "results": {
    "open_ports": [80, 443],
    "headers": {
      "Server": "Apache/2.4.49",
      "X-Powered-By": "PHP/7.4.3"
    },
    "ai_report": "Detailed markdown report..."
  }
}
```

---

#### GET `/health`
Health check de l'API

**Response (200):**
```json
{
  "status": "healthy",
  "version": "1.0.0"
}
```

---

## ⚙️ Configuration

### Variables d'Environnement Principales

| Variable | Description | Défaut |
|----------|-------------|--------|
| `ENVIRONMENT` | Mode (development/production) | development |
| `DEBUG` | Mode debug | true |
| `DATABASE_URL` | URL PostgreSQL | postgresql://... |
| `GEMINI_API_KEY` | Clé API Google Gemini | - |
| `REDIS_URL` | URL Redis | redis://redis:6379 |
| `JWT_SECRET` | Clé JWT | - |
| `NMAP_TIMEOUT` | Timeout Nmap (s) | 300 |
| `MAX_CONCURRENT_SCANS` | Max scans parallèles | 5 |

### Fichiers de Configuration
- `.env` - Variables d'environnement
- `docker-compose.yml` - Services Docker
- `nginx.conf` - Configuration Nginx
- `prometheus.yml` - Configuration Prometheus
- `loki-config.yml` - Configuration Loki

---

## 🔐 Sécurité

### Bonnes Pratiques

#### 1. Scope & Autorisation
- ✅ **TOUJOURS** obtenir une autorisation écrite avant un scan
- ✅ Utiliser uniquement des cibles autorisées (HackTheBox, Vulnhub, etc.)
- ✅ Maintenir un audit des scans lancés

#### 2. Isolation Réseau
```bash
# Docker network isolée
docker network inspect pentest-network

# Aucune fuite réseau vers l'extérieur
# Port Nmap: localhostuni uniquement
```

#### 3. Authentification
```python
# JWT Token required pour routes sensibles
Authorization: Bearer <token>
```

#### 4. Logs & Audit
- Tous les scans sont loggés dans Loki
- Accessible via Grafana
- Rétention: 30 jours

### Configuration de Sécurité

#### Variables Sensibles
```bash
# JAMAIS committer les secrets
.env est dans .gitignore

# En production:
export GEMINI_API_KEY="..."
export JWT_SECRET="$(openssl rand -hex 32)"
export POSTGRES_PASSWORD="$(openssl rand -base64 32)"
```

#### CORS
```python
# Frontend autorisé
CORS_ORIGINS = ["http://localhost", "http://localhost:80"]

# Autres origines: ajouter à .env
```

#### HTTPS
```bash
# Générer certificats Let's Encrypt
docker-compose exec api certbot certonly --webroot -w /app/frontend ...

# Configurer nginx.conf avec cert paths
```

---

## 🐛 Dépannage

### Problèmes Courants

#### 1. API non répondante
```bash
# Vérifier les logs
docker-compose logs api

# Vérifier la DB
docker-compose exec db psql -U pentest -d pentest_db -c "SELECT 1;"

# Redémarrer le service
docker-compose restart api
```

#### 2. Erreur de connexion DB
```bash
# Vérifier la DB
docker-compose ps db

# Vérifier les connexions
docker-compose logs db | grep "connection"

# Réinitialiser
docker-compose down db
docker volume rm cyber-pentest_postgres_data
docker-compose up -d db
```

#### 3. Scans ne démarrent pas
```bash
# Vérifier Nmap
docker-compose exec api which nmap

# Vérifier les permissions
docker-compose exec api ls -la /app

# Logs API
docker-compose logs api | grep -i error
```

#### 4. Frontend ne charge pas
```bash
# Vérifier Nginx
docker-compose logs frontend

# Tester la connexion
curl http://localhost

# Vérifier les fichiers
docker-compose exec frontend ls -la /usr/share/nginx/html
```

### Commandes Utiles

```bash
# Tout redémarrer
docker-compose restart

# Voir tous les containers
docker-compose ps

# Exécuter une commande
docker-compose exec api python main.py

# Voir les logs en temps réel
docker-compose logs -f

# Arrêter tout
docker-compose down

# Nettoyer les volumes
docker-compose down -v
```

---

## 📊 Monitoring

### Accéder aux dashboards

#### Grafana
- URL: http://localhost:3000
- Admin: admin / admin
- Dashboards préconfigurés pour Loki, Prometheus

#### Prometheus
- URL: http://localhost:9090
- Métriques API, Redis, DB

#### Loki
- URL: http://localhost:3100 (API uniquement)
- Visualisé via Grafana

### Métriques importantes
- Scan completion rate
- Temps moyen d'exécution
- Erreurs par type
- Vulnérabilités détectées
- Uptime des services

---

## 📝 Licence & Conformité

**⚠️ AVERTISSEMENT LÉGAL**

Ce projet est destiné à:
- ✅ Éducation en cybersécurité
- ✅ Tests autorisés (pentest professionnel)
- ✅ Environnements de laboratoire (HackTheBox, Vulnhub)

**INTERDIT:**
- ❌ Attaques non autorisées
- ❌ Accès sans permission
- ❌ Violation de lois locales

**Responsabilité de l'utilisateur**: Vous êtes responsable légalement de l'utilisation de cet outil.

---

## 📞 Support & Contribution

- **Issues**: https://github.com/your-repo/issues
- **Documentation**: [README.md](README.md)
- **API Docs**: http://localhost:8000/docs (Swagger UI)

---

**Cyber-Pentest v1.0** | Créé pour l'éducation en sécurité offensive
