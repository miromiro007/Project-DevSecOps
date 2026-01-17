# 🛡️ Cyber-Pentest - Plateforme Web de Pentesting Automatisé

![Status](https://img.shields.io/badge/Status-Active-green)
![License](https://img.shields.io/badge/License-Educational-blue)
![Python](https://img.shields.io/badge/Python-3.11-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)

## 📋 À Propos

**Cyber-Pentest** est une plateforme web complète permettant d'orchestrer et d'automatiser les phases principales d'un test d'intrusion (Penetration Testing) dans un cadre:
- 🔐 **Sécurisé** - Containerisation isolée
- ⚖️ **Légal** - Authentification & audit complet
- 🎓 **Pédagogique** - Interface intuitive et documentée

### Phases Supportées
1. **Footprinting** - Reconnaissance passive via en-têtes HTTP
2. **Scanning** - Détection ports (Nmap)
3. **Exploitation** - Identification vulnérabilités
4. **Post-Exploitation** - Analyse des privilèges
5. **Persistance** - Simulation maintien d'accès
6. **Reporting** - Rapports IA automatisés (Google Gemini)

---

## 🎯 Caractéristiques

### Frontend
✅ Interface web responsive  
✅ Dashboard temps réel  
✅ Suivi des scans en direct  
✅ Téléchargement rapports  
✅ Historique complet  
✅ Design moderne (HTML/CSS/JS vanilla)  

### Backend
✅ API RESTful FastAPI  
✅ Orchestration modulaire  
✅ Base de données PostgreSQL  
✅ Cache Redis  
✅ Support WebSocket  
✅ Logs centralisés (Loki)  

### Infra & DevOps
✅ Containerisation Docker Compose  
✅ Monitoring Prometheus/Grafana  
✅ Health checks intégrés  
✅ Networking isolé  
✅ Persistance des données  
✅ Multi-service scale-ready  

---

## 🚀 Démarrage Rapide

### Prérequis
- Docker & Docker Compose
- 4GB RAM minimum
- 20GB espace disque

### Installation (1 minute)

#### Linux / macOS
```bash
git clone https://github.com/your-repo/cyber-pentest.git
cd cyber-pentest
cp .env.example .env
# Éditer .env avec votre GEMINI_API_KEY
./deploy.sh
```

#### Windows
```cmd
git clone https://github.com/your-repo/cyber-pentest.git
cd cyber-pentest
copy .env.example .env
REM Éditer .env avec votre GEMINI_API_KEY
deploy.bat
```

### Accès aux services
| Service | URL |
|---------|-----|
| **Interface** | http://localhost |
| **API** | http://localhost:8000 |
| **Swagger Docs** | http://localhost:8000/docs |
| **Grafana** | http://localhost:3000 |
| **Prometheus** | http://localhost:9090 |

---

## 📚 Guides

- 📖 **[QUICKSTART.md](QUICKSTART.md)** - Premiers pas (5 min)
- 📖 **[DOCUMENTATION.md](DOCUMENTATION.md)** - Documentation complète
- 📖 **[API Endpoints](#-api-endpoints)** - Référence API

---

## 🔌 API Endpoints

### POST `/scan`
Lancer un nouveau scan pentest

```bash
curl -X POST http://localhost:8000/scan \
  -H "Content-Type: application/json" \
  -d '{"target_url": "https://httpbin.org"}'
```

**Response:**
```json
{
  "scan_id": "550e8400-e29b-41d4-a716-446655440000",
  "message": "Scan started"
}
```

### GET `/status/{scan_id}`
Récupérer le statut du scan

```bash
curl http://localhost:8000/status/550e8400-e29b-41d4-a716-446655440000
```

### GET `/health`
Vérifier la santé de l'API

```bash
curl http://localhost:8000/health
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│      Frontend (Nginx)               │
│   HTML/CSS/JavaScript vanilla       │
└──────────────┬──────────────────────┘
               │
        ┌──────▼──────┐
        │  FastAPI    │
        │  Backend    │
        └──────┬──────┘
               │
      ┌────────┴─────────┐
      │                  │
   PostgreSQL         Redis
   (Scan Data)        (Cache)
   
Monitoring: Prometheus → Grafana
Logs: Loki via Grafana
```

---

## 📂 Structure du Projet

```
cyber-pentest/
├── frontend/                  # Interface web
│   ├── index.html            # Markup
│   ├── styles.css            # Styles modernes
│   └── script.js             # Logique client
├── workflow/                 # Modules pentest
│   ├── footprinting.py      # Recon
│   ├── scanning.py          # Nmap integration
│   ├── exploitation.py       # Vuln detection
│   ├── post_exploitation.py # Privilege analysis
│   ├── persistence.py        # Persistence sim
│   └── reporting.py          # AI reports
├── utils/                    # Utilitaires
│   ├── db.py                # Database
│   ├── logger.py            # Logging
│   └── command_runner.py     # Shell commands
├── main.py                   # API FastAPI
├── models.py                 # DB Models
├── requirements.txt          # Python deps
├── Dockerfile               # API image
├── docker-compose.yml       # Orchestration
├── nginx.conf              # Web server config
├── prometheus.yml          # Metrics config
├── loki-config.yml         # Logs config
├── .env.example            # Environment template
├── deploy.sh               # Auto-deploy (Linux)
├── deploy.bat              # Auto-deploy (Windows)
├── QUICKSTART.md           # Quick guide
├── DOCUMENTATION.md        # Full docs
└── README.md              # This file
```

---

## ⚙️ Configuration

### Variables Environnement Essentielles

```bash
# API
ENVIRONMENT=development
GEMINI_API_KEY=your_api_key_here

# Database
DATABASE_URL=postgresql://pentest:password@db:5432/pentest_db

# Security
JWT_SECRET=your_secret_key_here

# Redis
REDIS_URL=redis://:password@redis:6379/0
```

Voir [.env.example](.env.example) pour tous les paramètres.

---

## 🔐 Sécurité

### ⚠️ AVERTISSEMENT LÉGAL

Ce projet est destiné à:
- ✅ **Éducation** en cybersécurité
- ✅ **Tests autorisés** (pentest professionnel)
- ✅ **Environnements de lab** (HackTheBox, Vulnhub)

Strictement **INTERDIT**:
- ❌ Attaques non autorisées
- ❌ Accès sans permission écrite
- ❌ Violation des lois locales

**Vous êtes légalement responsable** de l'utilisation de cet outil.

### Cibles Légales pour Tester
- 🎯 httpbin.org
- 🎯 HackTheBox.com
- 🎯 Vulnhub.com
- 🎯 CTF platforms
- 🎯 Vos propres serveurs

### Bonnes Pratiques
1. Toujours obtenir une **autorisation écrite**
2. Documenter **tous les tests**
3. Utiliser des **réseaux isolés**
4. Maintenir un **audit complet**
5. Respecter **les lois locales**

---

## 📊 Services Docker

| Service | Port | Description |
|---------|------|-------------|
| **frontend** | 80 | Nginx web server |
| **api** | 8000 | FastAPI backend |
| **db** | 5432 | PostgreSQL database |
| **redis** | 6379 | Cache & sessions |
| **loki** | 3100 | Log aggregation |
| **prometheus** | 9090 | Metrics collection |
| **grafana** | 3000 | Dashboards |

---

## 🛠️ Commandes Utiles

### Démarrage
```bash
docker-compose up -d          # Démarrer tous les services
docker-compose logs -f api    # Voir les logs en temps réel
docker-compose ps             # État des services
```

### Arrêt
```bash
docker-compose stop           # Arrêter les services
docker-compose restart        # Redémarrer
docker-compose down           # Arrêter et supprimer
docker-compose down -v        # Arrêter et purger données
```

### Dépannage
```bash
docker-compose logs db              # Logs PostgreSQL
docker-compose exec db psql -U ...  # Accès BD
docker-compose exec api bash        # Shell API
```

---

## 📈 Monitoring & Logs

### Grafana Dashboards
- URL: http://localhost:3000
- Login: admin / admin
- Métriques: Prometheus
- Logs: Loki

### Prometheus Metrics
- URL: http://localhost:9090
- API health
- Database connectivity
- Scan performance

### Loki Logs
- Centralized logging
- Visualized via Grafana
- Full audit trail
- 30-day retention

---

## 🐛 Dépannage

### API ne répond pas
```bash
docker-compose logs api
docker-compose restart api
```

### Base de données erreur
```bash
docker-compose logs db
docker-compose down db && docker-compose up -d db
```

### Frontend ne charge pas
```bash
curl http://localhost
docker-compose logs frontend
```

Plus de solutions: voir [DOCUMENTATION.md](DOCUMENTATION.md#-dépannage)

---

## 📦 Dépendances

### Backend (Python)
```
fastapi>=0.95.0
uvicorn[standard]>=0.21.0
python-nmap
sqlalchemy>=2.0.0
psycopg2-binary
redis
google-generativeai
pydantic
requests
```

### Frontend
- HTML5
- CSS3
- JavaScript (vanilla)
- Aucune dépendance externe

### Infra
- Docker 20.10+
- Docker Compose 1.29+
- PostgreSQL 15
- Redis 7
- Nginx Alpine
- Grafana/Prometheus/Loki

---

## 🔄 Cycle de Vie d'un Scan

```
1. Utilisateur lance scan
        ↓
2. API crée entry BD
        ↓
3. Footprinting → Analyse en-têtes HTTP
        ↓
4. Scanning → Nmap détection ports
        ↓
5. Exploitation → Vuln detection
        ↓
6. Post-Exploitation → Privilege analysis
        ↓
7. Persistence → Maintain access sim
        ↓
8. Reporting → Generate AI report
        ↓
9. Résultats sauvegardés BD
        ↓
10. Frontend affiche rapport
```

---

## 🎓 Prochaines Améliorations

- [ ] Authentification JWT complète
- [ ] Contrôle d'accès basé sur rôles
- [ ] Intégration OpenVAS
- [ ] Intégration Gobuster
- [ ] Intégration Nikto
- [ ] Templates rapports personnalisés
- [ ] Export PDF
- [ ] Gestion de projets
- [ ] Webhooks notifications
- [ ] Slack/Email alerts

---

## 📞 Support & Contribution

- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/discussions)
- **Documentation**: [Full Docs](DOCUMENTATION.md)
- **API Reference**: http://localhost:8000/docs

### Contributions bienvenues!
1. Fork le projet
2. Créer une branche (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Ouvrir une Pull Request

---

## 📝 Licence

**Educational Purpose Only** - À utiliser responsablement

```
Ce projet est fourni "tel quel" à des fins éducatives.
L'utilisateur est responsable légal de son utilisation.
Respectez les lois locales et obtenir les autorisations nécessaires.
```

---

## 🙏 Remerciements

- Google Gemini API pour les rapports IA
- OWASP pour les frameworks pentest
- La communauté cybersécurité open-source
- HackTheBox & Vulnhub pour les labs

---

## 📞 Contact

- **Documentation**: [DOCUMENTATION.md](DOCUMENTATION.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Email**: your-email@example.com

---

**Cyber-Pentest v1.0** | Créé pour l'éducation en sécurité offensive ⚔️

*Remember: With great power comes great responsibility. Use this tool ethically!*
