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

# Copier les fichiers statiques (CSS, JS, images) si manquants
if [ ! -d "/data/static" ]; then
    echo "Copie des fichiers statiques..."
    cp -r /app/static /data/ 2>/dev/null || true
fi

# Copier le dossier src si nécessaire pour les routes
if [ ! -d "/data/src" ]; then
    echo "Copie du code source..."
    cp -r /app/src /data/ 2>/dev/null || true
fi

# Télécharger et extraire les données du model viewer si nécessaire
if [ ! -d "/data/meta" ]; then
    echo "Téléchargement des données du model viewer..."
    
    URLS=(
        "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/latest/download/data.tar.gz"
        "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/download/v1.0.0/data.tar.gz"
        "https://github.com/whit3str/azerothcore-armory/releases/latest/download/data.tar.gz"
    )
    
    DOWNLOADED=false
    for url in "${URLS[@]}"; do
        echo "Tentative de téléchargement depuis: $url"
        if curl -L -f -o /tmp/modelviewer-data.tar.gz "$url" 2>/dev/null; then
            echo "Téléchargement réussi, extraction en cours..."
            cd /data
            if tar -xzf /tmp/modelviewer-data.tar.gz; then
                echo "Extraction terminée avec succès"
                rm /tmp/modelviewer-data.tar.gz
                DOWNLOADED=true
                break
            else
                echo "Échec de l'extraction"
                rm -f /tmp/modelviewer-data.tar.gz
            fi
        fi
    done
    
    if [ "$DOWNLOADED" = false ]; then
        echo "ATTENTION: Impossible de télécharger automatiquement les données"
    fi
fi

# Créer le lien symbolique
rm -rf /app/data
ln -sf /data /app/data

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
