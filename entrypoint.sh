#!/bin/bash

echo "Initialisation de l'armory AzerothCore..."

# Copier le fichier de config par défaut
if [ ! -f /data/config.json ]; then
    echo "Copie du fichier de configuration par défaut..."
    cp /defaults/config.json /data/config.json
fi

# Copier les fichiers CSV du repository
echo "Copie des fichiers de données CSV..."
cp -r /app/data-template/* /data/ 2>/dev/null || true

# Tentative de téléchargement des données du model viewer
if [ ! -d "/data/meta" ]; then
    echo "Tentative de téléchargement des données du model viewer..."
    
    # Essayer plusieurs URLs possibles
    URLS=(
        "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/latest/download/modelviewer-data.zip"
        "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/download/v1.0.0/modelviewer-data.zip"
        "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/latest/download/data.zip"
    )
    
    DOWNLOADED=false
    for url in "${URLS[@]}"; do
        echo "Essai de téléchargement depuis: $url"
        if curl -L -f -o /tmp/modelviewer-data.zip "$url" 2>/dev/null; then
            echo "Téléchargement réussi depuis $url"
            if unzip -q /tmp/modelviewer-data.zip -d /data/ 2>/dev/null; then
                echo "Extraction réussie"
                rm /tmp/modelviewer-data.zip
                DOWNLOADED=true
                break
            else
                echo "Échec de l'extraction"
                rm -f /tmp/modelviewer-data.zip
            fi
        else
            echo "Échec du téléchargement depuis $url"
        fi
    done
    
    if [ "$DOWNLOADED" = false ]; then
        echo "ATTENTION: Impossible de télécharger les données du model viewer"
        echo "L'application peut ne pas fonctionner correctement sans ces données"
        echo "Veuillez télécharger manuellement les données depuis:"
        echo "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases"
    fi
fi

# Créer le lien symbolique
rm -rf /app/data
ln -sf /data /app/data

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
