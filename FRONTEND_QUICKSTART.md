# 🚀 Guide de Démarrage Rapide - Frontend FUSE Security Scanner

## Installation Express

### 1️⃣ Prérequis
```bash
# Python 3.8+
python --version

# Nmap (pour le scanning de ports)
# Windows: Téléchargez depuis https://nmap.org/download.html
# Linux: sudo apt-get install nmap
# Mac: brew install nmap
nmap --version
```

### 2️⃣ Installation
```bash
# Cloner/Accéder au projet
cd cybersecurity_backend-main

# Installer les dépendances
pip install fastapi uvicorn sqlalchemy pymysql python-dotenv requests nmap3 google-generativeai python-multipart aiofiles

# Ou via requirements.txt
pip install -r requirements.txt
```

### 3️⃣ Configuration
Créez `.env` à la racine :
```env
DATABASE_URL=mysql+pymysql://root:12345@localhost:3306/pentest_db
GEMINI_API_KEY=votre_clé_api_gemini_ici
```

> **Note** : Pour obtenir une clé Gemini gratuite : https://makersuite.google.com/app/apikey

### 4️⃣ Lancement
```bash
# Démarrer le serveur
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 5️⃣ Accès
```
🌐 Frontend : http://localhost:8000
📊 API Docs : http://localhost:8000/docs
🔧 Preview  : http://localhost:8000/static/preview.html
```

## 🎯 Utilisation en 30 secondes

1. **Ouvrez** http://localhost:8000
2. **Entrez** une URL (ex: https://example.com)
3. **Cliquez** sur "Démarrer le Scan"
4. **Regardez** la magie opérer en temps réel ! ✨

## 📸 Ce que vous verrez

### 🎨 Interface
- Design moderne dark theme avec gradients
- Navigation fluide et responsive
- Animations et transitions élégantes
- Console en temps réel façon terminal hacker

### 📊 Pendant le scan
- **6 étapes visuelles** : Footprinting → Scanning → Exploitation → Post-Exploitation → Persistence → Reporting
- **Barre de progression** : 0% → 100%
- **Statistiques live** :
  - 🐛 Nombre de vulnérabilités
  - 🚪 Ports ouverts
  - ⏱️ Durée du scan
  - 📝 Nombre de logs
- **Console en direct** : Tous les événements en temps réel

### 📋 Résultats
- **Statut de sécurité** : Optimal / Risque Modéré / Risque Élevé
- **Serveur détecté** : Apache, Nginx, etc.
- **Ports ouverts** : Liste avec badges colorés
- **En-têtes de sécurité** : Présents (vert) / Manquants (rouge)
- **Rapport IA** : Analyse complète par Gemini avec recommandations

## 🛠️ Résolution de Problèmes

### ❌ Backend Offline (point rouge)
```bash
# Vérifier que le serveur tourne
uvicorn main:app --reload

# Vérifier le port
netstat -an | findstr 8000
```

### ❌ Erreur lors du scan
```bash
# Vérifier Nmap
nmap --version

# Sur Windows, ajouter Nmap au PATH
```

### ❌ Pas de rapport IA
```bash
# Vérifier la clé dans .env
echo $GEMINI_API_KEY

# Le scan fonctionne quand même sans IA !
```

## 🎨 Personnalisation Rapide

### Changer les couleurs
Éditez `static/styles.css` ligne 7-10 :
```css
:root {
    --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    --bg-dark: #0f0f23;
}
```

### Modifier l'URL de l'API
Éditez `static/app.js` ligne 5 :
```javascript
const API_URL = 'http://votre-serveur:8000';
```

## 📦 Structure des fichiers Frontend

```
static/
├── index.html       # ⭐ Application principale
├── styles.css       # 🎨 Tous les styles
├── app.js          # ⚡ Logique & API calls
├── preview.html    # 👀 Page de présentation
└── README.md       # 📖 Documentation complète
```

## 🌟 Fonctionnalités Clés

### ✅ Ce qui marche dès maintenant
- ✅ Interface complète et responsive
- ✅ Scan en temps réel avec 6 phases
- ✅ Console live avec logs colorés
- ✅ Statistiques dynamiques
- ✅ Résultats détaillés
- ✅ Rapport IA formaté en Markdown
- ✅ Téléchargement du rapport
- ✅ Vérification d'état du backend
- ✅ Gestion des erreurs
- ✅ Validation des URLs

### 🎯 Points forts du design
- 🌑 Dark theme moderne
- 🎨 Gradients et ombres élégants
- 🔄 Animations fluides
- 📱 100% responsive
- ⚡ Performance optimisée (Vanilla JS)
- 🎭 Icônes Font Awesome
- 🔤 Police Inter (Google Fonts)

## 🔐 Conseils de Sécurité

### ⚠️ Important
- Ne scannez **QUE** vos propres systèmes ou avec autorisation écrite
- Utilisez dans un environnement de test isolé
- Ne partagez jamais votre clé API Gemini
- En production, ajoutez une authentification

### 🛡️ URLs de test légales
```
https://scanme.nmap.org          # Officiellement autorisé par Nmap
http://testphp.vulnweb.com       # Site de test Acunetix
http://testhtml5.vulnweb.com     # Site de test HTML5
https://example.com              # Site d'exemple basique
```

## 📚 Prochaines Étapes

1. ✅ **Lancez votre premier scan** avec une URL de test
2. 📖 Lisez la [Documentation Complète](README.md)
3. 🔧 Personnalisez les couleurs et le style
4. 🚀 Testez sur vos propres applications (avec autorisation)
5. 📊 Analysez les rapports générés par l'IA

## 💡 Astuces Pro

### 🚀 Performance
- Le polling se fait toutes les 1 seconde
- Les logs s'ajoutent sans rafraîchir la page
- Les animations CSS sont GPU-accélérées

### 🎨 Design
- Toutes les couleurs sont dans les CSS variables
- Grid & Flexbox pour le layout responsive
- Transitions CSS pour la fluidité

### 🔧 Développement
```bash
# Mode développement avec rechargement auto
uvicorn main:app --reload

# Voir les logs détaillés
uvicorn main:app --reload --log-level debug
```

## 📞 Besoin d'aide ?

- 📖 Lisez [DOCUMENTATION.md](../DOCUMENTATION.md)
- 🔍 Consultez [API.md](../docs/API.md)
- 🐛 Vérifiez les logs du backend
- 🌐 Ouvrez la console navigateur (F12)

---

**Prêt à scanner ?** 🚀  
Lancez `uvicorn main:app --reload` et ouvrez http://localhost:8000 !

*FUSE Security Scanner - Sécurisez vos applications avec style* 🛡️✨
