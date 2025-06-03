FROM node:16

# Définir le répertoire de travail
WORKDIR /app

# Créer les dossiers nécessaires dans l'image
RUN mkdir -p /data /logs /defaults

# Copier les fichiers de dépendances en premier (pour optimiser le cache Docker)
COPY package*.json ./

# Installation des dépendances
RUN npm install

# Copier tout le code source
COPY . .

# Copier explicitement le dossier data du repository vers /app/data
COPY data/ ./data/

# Créer un lien symbolique vers /data pour la compatibilité avec le volume
RUN ln -sf /app/data /data/default

# Copier et renommer le fichier de config par défaut
COPY config.default.json /defaults/config.json

# Build de l'application
RUN npm run build

# Script d'initialisation des données
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
