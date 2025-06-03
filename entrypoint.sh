#!/bin/bash

echo "Initialisation de l'armory AzerothCore..."

# Copier le fichier de config par défaut si nécessaire
if [ ! -f /data/config.json ]; then
    echo "Copie du fichier de configuration par défaut..."
    cp /defaults/config.json /data/config.json
    echo "Fichier de configuration copié"
fi

# Vérifier si les données du model viewer sont présentes
if [ ! -d "/data/meta" ] || [ ! -f "/data/meta/charactercustomization2/1_0.json" ]; then
    echo "Copie des données du model viewer..."
    cp -r /app/data-template/* /data/ 2>/dev/null || true
    echo "Données du model viewer copiées"
fi

# Créer le lien symbolique pour que l'application trouve les données
if [ -L "/app/data" ]; then
    rm /app/data
fi
if [ -d "/app/data" ]; then
    rm -rf /app/data
fi
ln -sf /data /app/data

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
