# 🚀 Cyber-Pentest - Guide de Démarrage Rapide

## Installation Rapide (5 minutes)

### Étape 1️⃣: Cloner le projet
```bash
git clone https://github.com/your-repo/cyber-pentest.git
cd cyber-pentest
```

### Étape 2️⃣: Configuration
```bash
# Copier le fichier d'environnement
cp .env.example .env

# IMPORTANT: Ajouter votre clé API Gemini
# nano .env
# Chercher GEMINI_API_KEY et ajouter votre clé
```

### Étape 3️⃣: Démarrer les services
```bash
docker-compose up -d
```

Vérifier que tout démarre:
```bash
docker-compose ps
```

Vous devriez voir:
```
NAME                        STATUS
cyber-pentest-frontend      Up (healthy)
cyber-pentest-api           Up (healthy)
cyber-pentest-db            Up (healthy)
cyber-pentest-redis         Up
cyber-pentest-loki          Up
cyber-pentest-prometheus    Up
cyber-pentest-grafana       Up
```

### Étape 4️⃣: Accéder à l'application

| Service | URL |
|---------|-----|
| **Frontend** | http://localhost |
| **API** | http://localhost:8000 |
| **Swagger API Docs** | http://localhost:8000/docs |
| **Grafana** | http://localhost:3000 (admin/admin) |
| **Prometheus** | http://localhost:9090 |

---

## 🧪 Lancer votre premier scan

### Via l'Interface Web
1. Ouvrir http://localhost
2. Entrer une URL cible: `https://httpbin.org` (sûr pour tester)
3. Cliquer "🚀 Démarrer Scan"
4. Suivre la progression
5. Télécharger le rapport

### Via API (cURL)
```bash
# Lancer un scan
curl -X POST http://localhost:8000/scan \
  -H "Content-Type: application/json" \
  -d '{"target_url": "https://httpbin.org"}'

# Récupérer le scan_id de la réponse, puis:
curl http://localhost:8000/status/SCAN_ID
```

---

## 🔑 Configuration API Gemini (IMPORTANT)

### Obtenir une clé API
1. Aller sur: https://makersuite.google.com/app/apikey
2. Cliquer "Create API Key"
3. Copier la clé
4. Éditer `.env`:
   ```bash
   GEMINI_API_KEY=your_key_here
   ```
5. Redémarrer l'API:
   ```bash
   docker-compose restart api
   ```

---

## ⚠️ Cibles Légales pour Tester

- ✅ **httpbin.org** - API de test simple
- ✅ **HackTheBox** - Lab de cybersécurité
- ✅ **Vulnhub.com** - Machines vulnérables
- ✅ **CTFd** - Capture The Flag
- ✅ **Vos propres serveurs** (avec permission!)

---

## 🛑 Arrêter les services

```bash
# Arrêter sans supprimer
docker-compose stop

# Redémarrer
docker-compose start

# Arrêter et supprimer (careful!)
docker-compose down

# Supprimer aussi les données (reset complet)
docker-compose down -v
```

---

## 📊 Vérifier l'état

```bash
# Logs API
docker-compose logs -f api

# Logs BD
docker-compose logs -f db

# Tout
docker-compose logs -f
```

---

## 🆘 Dépannage Rapide

### Frontend ne charge pas
```bash
curl http://localhost
# Si erreur: vérifier docker-compose logs frontend
```

### API erreur
```bash
curl http://localhost:8000/health
# Réponse: {"status": "healthy"}
```

### BD ne démarre pas
```bash
docker-compose logs db
# Vérifier disk space et mémoire
```

---

## 📝 Structure du Projet

```
cyber-pentest/
├── frontend/              # Interface web
│   ├── index.html
│   ├── styles.css
│   └── script.js
├── workflow/              # Modules pentest
│   ├── footprinting.py
│   ├── scanning.py
│   ├── exploitation.py
│   ├── post_exploitation.py
│   ├── persistence.py
│   └── reporting.py
├── utils/                 # Utilitaires
│   ├── db.py
│   ├── logger.py
│   └── command_runner.py
├── main.py               # API FastAPI
├── models.py             # BD Models
├── docker-compose.yml    # Orchestration
├── Dockerfile            # Image API
├── nginx.conf            # Config Nginx
├── requirements.txt      # Python deps
└── .env.example          # Template env
```

---

## 🎓 Prochaines Étapes

### 1. Intégrer plus d'outils
- OpenVAS (scan vulnérabilités avancé)
- Gobuster (brute-force répertoires)
- Nikto (scanner web)
- SQLMap (injection SQL)

### 2. Ajouter Authentification
- JWT tokens
- Rôles utilisateurs
- Rate limiting

### 3. Améliorer les rapports
- Templates personnalisés
- Export PDF
- Graphiques
- Métriques détaillées

### 4. Intégrer OSINT
- Whois lookup
- DNS enumeration
- IP reconnaissance

---

## 📚 Ressources

- [Documentation Complète](DOCUMENTATION.md)
- [API Swagger](http://localhost:8000/docs)
- [OWASP Pentest Guide](https://owasp.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

## ⚠️ Rappel Légal

**CE PROJET EST DESTINÉ À L'ÉDUCATION UNIQUEMENT**

- ✅ Tester uniquement les systèmes autorisés
- ✅ Respecter les lois locales
- ✅ Garder des traces d'audit
- ❌ Ne pas attaquer sans permission

**Utilisateur = Responsable légal de ses actions**

---

**Bon pent€$ting! 🎯**
