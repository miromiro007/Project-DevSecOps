# 🐳 Docker - Checklist de Rebuild

## ✅ Avant de Rebuilder

- [ ] Sauvegarder les données importantes (DB, rapports)
- [ ] Vérifier que Docker est installé et lancé
- [ ] Arrêter les conteneurs existants si nécessaire
- [ ] Vérifier l'espace disque disponible (>2GB recommandé)
- [ ] Fermer les applications utilisant les ports 80, 8000, 3306

## 🔨 Options de Rebuild

### Option 1 : Script Automatique (RECOMMANDÉ)

**Windows :**
```bash
rebuild.bat
```

**Linux/Mac :**
```bash
chmod +x rebuild.sh && ./rebuild.sh
```

Choisissez ensuite :
- **1** = Rebuild complet (après modification Dockerfile/requirements)
- **2** = Rebuild rapide (après modification du code)
- **3** = Redémarrer (après modification .env)
- **4** = Voir les logs
- **5** = Arrêter tout

### Option 2 : Commandes Manuelles

**Rebuild Complet :**
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**Rebuild Rapide :**
```bash
docker-compose build
docker-compose up -d --force-recreate
```

## 📊 Après le Rebuild

### Vérification
```bash
# Voir l'état
docker-compose ps

# Tous les conteneurs doivent être "Up (healthy)"
```

### Tester les URLs
- [ ] http://localhost - Frontend
- [ ] http://localhost:8000 - API
- [ ] http://localhost:8000/docs - Documentation
- [ ] http://localhost:8000/health - Health check

### Vérifier les Logs
```bash
docker-compose logs -f --tail=50
```

## 🐛 En Cas de Problème

### Conteneur ne démarre pas
```bash
# Voir les logs
docker-compose logs nom_du_service

# Exemples :
docker-compose logs api
docker-compose logs db
docker-compose logs frontend
```

### Port déjà utilisé
```bash
# Windows
netstat -ano | findstr :8000

# Linux/Mac
lsof -i :8000

# Solution : Arrêter le processus ou changer le port
```

### Rebuild échoue
```bash
# Nettoyer tout et recommencer
docker-compose down -v
docker system prune -a
docker-compose build --no-cache
docker-compose up -d
```

## 💡 Commandes Utiles

```bash
# Logs en temps réel
docker-compose logs -f

# Accéder au shell du conteneur API
docker-compose exec api bash

# Redémarrer un service spécifique
docker-compose restart api

# Arrêter tout
docker-compose down

# Tout supprimer (ATTENTION !)
docker-compose down -v
docker system prune -a --volumes
```

## 🎯 Quand Utiliser Quel Type de Rebuild

| Modification | Type de Rebuild | Commande |
|-------------|-----------------|----------|
| Code Python/Frontend | Rapide | `rebuild.sh` → 2 |
| Dockerfile | Complet | `rebuild.sh` → 1 |
| requirements.txt | Complet | `rebuild.sh` → 1 |
| .env / Config | Redémarrer | `rebuild.sh` → 3 |
| docker-compose.yml | Complet | `rebuild.sh` → 1 |

## ⏱️ Durées Estimées

- **Rebuild Complet** : 2-5 minutes
- **Rebuild Rapide** : 30 secondes - 1 minute
- **Redémarrage** : 10-20 secondes

## 📌 Notes Importantes

- ⚠️ Le rebuild complet supprime les anciennes images
- 💾 Les volumes de données (MySQL, Redis) sont persistants
- 🔄 Les logs sont accessibles en temps réel
- 🛡️ Les conteneurs utilisent des utilisateurs non-root pour la sécurité

---

**Prêt à rebuilder ! Lancez `rebuild.bat` (Windows) ou `./rebuild.sh` (Linux/Mac) 🚀**
