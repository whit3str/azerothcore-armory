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

# Vérifier si l'archive tar.gz est présente et l'extraire si nécessaire
ARCHIVE_PATH="/data/data.tar.gz"
if [ ! -d "/data/meta" ] && [ -f "$ARCHIVE_PATH" ]; then
    echo "Archive trouvée: $ARCHIVE_PATH"
    echo "Extraction en cours..."
    cd /data
    tar -xzf "$ARCHIVE_PATH"
    if [ $? -eq 0 ]; then
        echo "Extraction terminée avec succès"
        # Optionnel: supprimer l'archive après extraction
        # rm "$ARCHIVE_PATH"
    else
        echo "ERREUR: Échec de l'extraction de l'archive"
    fi
elif [ -d "/data/meta" ]; then
    echo "Données du model viewer déjà présentes"
elif [ ! -f "$ARCHIVE_PATH" ]; then
    echo "ATTENTION: Archive data.tar.gz non trouvée dans /data"
    echo "L'application peut ne pas fonctionner correctement"
fi

# Créer le lien symbolique
rm -rf /app/data
ln -sf /data /app/data

echo "Initialisation terminée. Démarrage de l'application..."

exec "$@"
