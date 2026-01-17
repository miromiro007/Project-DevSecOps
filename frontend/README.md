# 🛡️ FUSE Security Scanner - Frontend Guide

Interface web moderne et élégante pour effectuer des scans de sécurité automatisés avec IA.

## 🎨 Fonctionnalités du Frontend

### ✨ Interface Utilisateur
- **Design Moderne** : Interface sombre (dark theme) avec dégradés et animations fluides
- **Responsive** : Compatible desktop, tablette et mobile
- **Real-time Updates** : Mise à jour en temps réel de l'avancement du scan
- **Console Live** : Affichage des logs en direct comme dans un terminal

### 🔍 Fonctionnalités de Scan
1. **Footprinting** : Analyse des en-têtes HTTP et détection du serveur
2. **Port Scanning** : Détection des ports ouverts avec Nmap
3. **Exploitation** : Tests de vulnérabilités (SQLi, CVE, etc.)
4. **Post-Exploitation** : Analyse des vecteurs d'attaque
5. **Persistence** : Vérification des mécanismes de persistance
6. **Reporting IA** : Génération automatique de rapport avec Google Gemini

### 📊 Visualisations
- Progression en temps réel avec barre de progression
- Étapes visuelles du scan avec icônes animées
- Statistiques en direct (vulnérabilités, ports, durée)
- Graphiques et badges pour les résultats
- Rapport IA formaté en Markdown

## 🚀 Démarrage Rapide

### 1. Installation des dépendances
```bash
pip install -r requirements.txt
```

### 2. Configuration de l'environnement
Créez un fichier `.env` à la racine du projet :
```env
# Base de données (Neon PostgreSQL ou MySQL local)
DATABASE_URL=mysql+pymysql://root:12345@localhost:3306/pentest_db
# ou pour PostgreSQL
# DATABASE_URL=postgresql://user:password@host/database

# Clé API Gemini pour les rapports IA
GEMINI_API_KEY=votre_clé_api_gemini
```

### 3. Lancer le serveur backend
```bash
# Avec Uvicorn
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Ou avec Python
python -m uvicorn main:app --reload
```

### 4. Accéder à l'interface
Ouvrez votre navigateur et allez sur :
```
http://localhost:8000
```

## 📖 Utilisation

### Effectuer un Scan

1. **Entrez l'URL cible** dans le champ de saisie
   - Format : `https://example.com` ou `http://example.com`
   - L'URL doit commencer par http:// ou https://

2. **Cliquez sur "Démarrer le Scan"**
   - Le scan démarre immédiatement en arrière-plan
   - Un ID unique est généré pour suivre votre scan

3. **Suivez la progression en temps réel**
   - 6 étapes visuelles avec indicateurs colorés
   - Console en direct avec tous les logs
   - Statistiques mises à jour automatiquement
   - Barre de progression de 0% à 100%

4. **Consultez les résultats**
   - Statut de sécurité global (Optimal, Risque Modéré, Risque Élevé)
   - Liste des ports ouverts détectés
   - Vérification des en-têtes de sécurité
   - Rapport détaillé généré par l'IA Gemini

5. **Téléchargez le rapport**
   - Cliquez sur "Télécharger le Rapport"
   - Format Markdown (.md) pour documentation

## 🎨 Architecture du Frontend

### Fichiers
```
static/
├── index.html      # Structure HTML de l'application
├── styles.css      # Styles CSS avec design moderne
└── app.js          # Logique JavaScript et API calls
```

### Technologies Utilisées
- **HTML5** : Structure sémantique
- **CSS3** : Animations, gradients, grid/flexbox
- **Vanilla JavaScript** : Pas de framework, performance optimale
- **Font Awesome** : Icônes vectorielles
- **Google Fonts** : Police Inter pour une typographie moderne

### API Endpoints Utilisés
- `GET /health` : Vérifier l'état du backend
- `POST /scan` : Démarrer un nouveau scan
- `GET /status/{scan_id}` : Récupérer l'état d'un scan

## 🎯 Indicateurs Visuels

### Étapes du Scan
- 🔵 **En cours** : Bordure bleue, icône animée
- ✅ **Complété** : Bordure verte, fond vert clair
- ⚪ **En attente** : Bordure grise

### Statut de Sécurité
- ✓ **Optimal** : 0 vulnérabilités
- ⚠ **Risque Modéré** : 1-3 vulnérabilités
- ✗ **Risque Élevé** : 4+ vulnérabilités

### En-têtes de Sécurité
- 🟢 **Présent** : En-tête de sécurité configuré
- 🔴 **Manquant** : En-tête de sécurité absent

## 🔧 Personnalisation

### Modifier les couleurs
Éditez les variables CSS dans `styles.css` :
```css
:root {
    --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    --bg-dark: #0f0f23;
    --text-primary: #ffffff;
    /* ... autres variables ... */
}
```

### Changer l'URL de l'API
Modifiez la constante dans `app.js` :
```javascript
const API_URL = 'http://localhost:8000';
```

### Ajuster la fréquence de polling
Dans `app.js`, ligne ~92 :
```javascript
statusCheckInterval = setInterval(checkScanStatus, 1000); // 1000ms = 1 seconde
```

## 📱 Responsive Design

Le frontend s'adapte automatiquement à toutes les tailles d'écran :
- **Desktop** : Layout complet avec grilles multi-colonnes
- **Tablette** : Grilles 2 colonnes, navigation simplifiée
- **Mobile** : Layout vertical, boutons pleine largeur

## 🐛 Dépannage

### Le backend ne répond pas
- Vérifiez que le serveur est lancé sur le port 8000
- Vérifiez le statut dans la barre de navigation (point vert/rouge)
- Regardez la console du navigateur (F12) pour les erreurs

### Les scans ne se lancent pas
- Vérifiez que Nmap est installé sur votre système
- Vérifiez les permissions d'exécution
- Consultez les logs du backend dans le terminal

### Le rapport IA n'est pas généré
- Vérifiez que `GEMINI_API_KEY` est défini dans `.env`
- Vérifiez votre quota API Gemini
- Le scan continuera même sans rapport IA

## 🌟 Captures d'Écran

### Page d'Accueil
- Hero section avec titre gradient
- Formulaire de scan avec validation en temps réel
- Statut du backend visible

### Scan en Cours
- 6 étapes visuelles animées
- Console en direct style terminal
- Statistiques en temps réel (4 cartes)
- Barre de progression avec pourcentage

### Résultats
- Statut de sécurité avec couleurs
- Badges pour ports ouverts
- En-têtes de sécurité (présent/manquant)
- Rapport IA formaté et lisible

## 🔐 Sécurité

### Recommandations
- Ne scannez que des systèmes dont vous avez l'autorisation
- Utilisez un environnement isolé pour les tests
- Ne partagez pas votre clé API Gemini
- Protégez l'accès au frontend en production (authentification)

### CORS
Le backend autorise toutes les origines (`allow_origins=["*"]`).  
En production, restreignez à votre domaine :
```python
allow_origins=["https://votre-domaine.com"]
```

## 📚 Documentation Complète

Pour plus d'informations sur le backend et l'API :
- [API.md](../docs/API.md)
- [DOCUMENTATION.md](../DOCUMENTATION.md)
- [QUICKSTART.md](../QUICKSTART.md)

## 🤝 Contribution

Le design est modulaire et facile à personnaliser. N'hésitez pas à :
- Améliorer le design
- Ajouter de nouvelles visualisations
- Optimiser les performances
- Proposer de nouvelles fonctionnalités

## 📄 Licence

Ce projet est fourni à des fins éducatives et de recherche en sécurité.

---

**FUSE Security Scanner** - Sécurisez vos applications avec l'IA 🛡️✨
