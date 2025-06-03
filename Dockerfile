FROM node:16

# Créer les dossiers /data et /logs dans l'image
RUN mkdir -p /data /logs

# Copier les fichiers par défaut (ex: config.json) dans un dossier temporaire
COPY config.json /defaults/

# Installation des dépendances et build
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Script d'initialisation des données
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
