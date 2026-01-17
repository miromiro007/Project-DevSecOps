#!/bin/bash

# Cyber-Pentest - Affichage de la structure du projet

echo "📁 STRUCTURE DU PROJET CYBER-PENTEST"
echo "===================================="
echo ""

tree -L 2 -I '__pycache__|*.pyc|*.egg-info|.git' <<'EOF'
cyber-pentest/
│
├── 🌐 FRONTEND (Interface Web)
│   ├── frontend/
│   │   ├── index.html           ← Interface utilisateur
│   │   ├── styles.css           ← Design responsive
│   │   └── script.js            ← Logique client (vanilla)
│   └── nginx.conf               ← Configuration serveur web
│
├── 🔧 BACKEND (API & Orchestration)
│   ├── main.py                  ← Application FastAPI
│   ├── models.py                ← Modèles SQLAlchemy
│   ├── requirements.txt          ← Dépendances Python
│   ├── Dockerfile               ← Image Docker API
│   │
│   └── workflow/                ← Modules Pentest
│       ├── __init__.py
│       ├── footprinting.py      ← Phase 1: Reconnaissance
│       ├── scanning.py          ← Phase 2: Port Scan (Nmap)
│       ├── exploitation.py       ← Phase 3: Détection vulnérabilités
│       ├── post_exploitation.py ← Phase 4: Analyse post-exploitation
│       ├── persistence.py       ← Phase 5: Simulation persistance
│       └── reporting.py         ← Phase 6: Rapports IA (Gemini)
│
├── 📊 UTILITAIRES
│   └── utils/
│       ├── db.py                ← Connexion DB
│       ├── logger.py            ← Logging
│       └── command_runner.py     ← Exécution commandes
│
├── 🐳 ORCHESTRATION (Docker)
│   ├── docker-compose.yml       ← Services:
│   │                              - Frontend (Nginx)
│   │                              - API (FastAPI)
│   │                              - Database (PostgreSQL)
│   │                              - Cache (Redis)
│   │                              - Logs (Loki)
│   │                              - Metrics (Prometheus)
│   │                              - Dashboard (Grafana)
│   │
│   ├── prometheus.yml           ← Configuration métriques
│   └── loki-config.yml          ← Configuration logs
│
├── ⚙️ CONFIGURATION
│   ├── .env.example             ← Template variables environnement
│   ├── .gitignore               ← Fichiers à ignorer Git
│   │
│   ├── deploy.sh                ← Installation auto (Linux/Mac)
│   └── deploy.bat               ← Installation auto (Windows)
│
└── 📚 DOCUMENTATION
    ├── README.md                ← Vue d'ensemble
    ├── QUICKSTART.md            ← Guide 5 minutes
    ├── DOCUMENTATION.md         ← Documentation complète
    └── API.md                   ← Référence API
EOF

echo ""
echo "📊 SERVICES DOCKER"
echo "=================="
echo ""
echo "┌─────────────────────────┬──────────┬──────────────────┐"
echo "│ Service                 │ Port     │ Fonction         │"
echo "├─────────────────────────┼──────────┼──────────────────┤"
echo "│ 🌐 frontend (Nginx)     │ 80/443   │ Interface Web    │"
echo "│ 🔧 api (FastAPI)        │ 8000     │ Backend API      │"
echo "│ 🗄️ db (PostgreSQL)      │ 5432     │ Base données     │"
echo "│ 💾 redis (Cache)        │ 6379     │ Session/Cache    │"
echo "│ 📝 loki (Logs)          │ 3100     │ Logs centralisés │"
echo "│ 📈 prometheus (Metrics) │ 9090     │ Métriques        │"
echo "│ 📊 grafana (Dashboard)  │ 3000     │ Visualisation    │"
echo "└─────────────────────────┴──────────┴──────────────────┘"
echo ""

echo "🚀 DÉMARRAGE RAPIDE"
echo "==================="
echo ""
echo "1. Installation:"
echo "   ./deploy.sh (Linux/Mac)"
echo "   deploy.bat (Windows)"
echo ""
echo "2. Accès aux services:"
echo "   Frontend:   http://localhost"
echo "   API:        http://localhost:8000"
echo "   API Docs:   http://localhost:8000/docs"
echo "   Grafana:    http://localhost:3000 (admin/admin)"
echo ""
echo "3. Premiers pas:"
echo "   - Lire QUICKSTART.md pour démarrer en 5 minutes"
echo "   - Consulter DOCUMENTATION.md pour infos complètes"
echo ""

echo "📦 PHASES DU PENTEST AUTOMATISÉES"
echo "=================================="
echo ""
echo "1️⃣  Footprinting    → Analyse headers HTTP, reconnaissance passive"
echo "2️⃣  Scanning        → Détection ports avec Nmap"
echo "3️⃣  Exploitation    → Identification vulnérabilités"
echo "4️⃣  Post-Exploit    → Analyse privilèges, persistance"
echo "5️⃣  Persistance     → Simulation maintien d'accès"
echo "6️⃣  Reporting       → Génération rapports IA (Gemini)"
echo ""

echo "✨ CARACTÉRISTIQUES"
echo "==================="
echo ""
echo "✅ Interface web responsive"
echo "✅ API RESTful moderne"
echo "✅ Database PostgreSQL"
echo "✅ Cache Redis"
echo "✅ Monitoring Prometheus/Grafana"
echo "✅ Logs centralisés Loki"
echo "✅ Conteneurisation Docker"
echo "✅ Rapports IA automatisés"
echo "✅ Workflows modulaires"
echo "✅ Documentation complète"
echo ""

echo "⚠️ AVERTISSEMENT LÉGAL"
echo "====================="
echo ""
echo "✅ Utilisable pour:"
echo "   - Éducation en cybersécurité"
echo "   - Tests autorisés (pentest pro)"
echo "   - Labs de sécurité"
echo ""
echo "❌ INTERDIT:"
echo "   - Attaques non autorisées"
echo "   - Accès sans permission"
echo "   - Violation des lois"
echo ""
echo "👤 Responsabilité légale: Utilisateur"
echo ""
