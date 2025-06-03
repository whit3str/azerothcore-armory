#!/bin/bash

echo "Initialisation de l'armory AzerothCore..."

# Copier le fichier de config par défaut
if [ ! -f /data/config.json ]; then
    cp /defaults/config.json /data/config.json
    echo "Fichier de configuration par défaut copié"
fi

# Copier les fichiers CSV du repository
if [ ! -f "/data/Achievement_3.3.5_12340.csv" ]; then
    echo "Copie des fichiers CSV..."
    cp /app/data/* /data/ 2>/dev/null || true
fi

# Téléchargement des données du model viewer (votre code existant)
if [ ! -d "/data/meta" ]; then
    echo "Téléchargement des données du model viewer..."
    # ... votre code de téléchargement
fi

# SOLUTION : Créer les liens symboliques dans l'APPLICATION, pas dans le volume
echo "Configuration des chemins pour l'application..."

# Supprimer les anciens liens/dossiers
rm -rf /app/static /app/src

# Créer des liens symboliques DEPUIS l'app VERS le volume
ln -sf /data/static /app/static
ln -sf /data/src /app/src

# Assurer que les données sont accessibles via le chemin attendu par l'app
rm -rf /app/data
ln -sf /data /app/data

echo "Liens symboliques configurés :"
echo "  /app/static -> /data/static"
echo "  /app/src -> /data/src" 
echo "  /app/data -> /data"

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
