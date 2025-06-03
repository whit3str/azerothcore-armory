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

# Copier le dossier src si nécessaire
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
        echo "Vous pouvez placer manuellement l'archive data.tar.gz dans /data/"
    fi
elif [ -f "/data/data.tar.gz" ]; then
    # Si l'archive existe déjà localement, l'extraire
    echo "Archive locale trouvée, extraction..."
    cd /data
    tar -xzf data.tar.gz && rm data.tar.gz
fi

# Créer des liens symboliques pour que l'application trouve les fichiers
echo "Configuration des liens symboliques..."
if [ -d "/data/static" ]; then
    rm -rf /app/static
    ln -sf /data/static /app/static
    echo "Lien symbolique créé: /app/static -> /data/static"
fi

if [ -d "/data/src" ]; then
    rm -rf /app/src
    ln -sf /data/src /app/src
    echo "Lien symbolique créé: /app/src -> /data/src"
fi

# Créer le lien pour les données
rm -rf /app/data
ln -sf /data /app/data
echo "Lien symbolique créé: /app/data -> /data"

# Créer la structure URL attendue par l'application Express
echo "Configuration des routes statiques..."
mkdir -p /app/public/armory

# Créer des liens symboliques pour mapper les URLs /armory/css/ etc.
ln -sf /app/static/css /app/public/armory/css
ln -sf /app/static/js /app/public/armory/js
ln -sf /app/static/img /app/public/armory/img

echo "Routes statiques configurées :"
echo "  /app/public/armory/css -> /app/static/css"
echo "  /app/public/armory/js -> /app/static/js"
echo "  /app/public/armory/img -> /app/static/img"

echo "Vérification des fichiers CSS :"
ls -la /app/public/armory/css/ 2>/dev/null || echo "ATTENTION: Fichiers CSS non accessibles"

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
