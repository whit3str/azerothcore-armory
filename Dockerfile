FROM node:16

# Créer les dossiers /data et /logs dans l'image
RUN mkdir -p /data /logs /defaults

# Copier et renommer le fichier de config par défaut
COPY config.default.json /defaults/config.json

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
