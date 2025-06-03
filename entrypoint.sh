#!/bin/bash

echo "Initialisation des fichiers de config..."

# Copier le fichier de config par défaut si il n'existe pas
if [ ! -f /data/config.json ]; then
    cp /defaults/config.json /data/config.json
    echo "Fichier de configuration par défaut copié"
fi

# Vérifier si le dossier /data est vide (volume monté vide)
if [ ! -d "/data/meta" ]; then
    echo "Copie des données par défaut..."
    cp -r /app/data/* /data/
    echo "Données copiées avec succès"
fi

# Créer un lien symbolique pour que l'application trouve les données
if [ ! -L "/app/data" ]; then
    rm -rf /app/data
    ln -sf /data /app/data
fi

exec "$@"
