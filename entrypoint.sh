#!/bin/sh
set -e

# Copier les fichiers par défaut dans /data si le dossier est vide
if [ -z "$(ls -A /data)" ]; then
  echo "Initialisation des fichiers de config..."
  cp /defaults/config.json /data/
fi

# Exécuter la commande principale (npm start)
exec "$@"
