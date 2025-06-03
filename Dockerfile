FROM node:16

WORKDIR /app

# Installer curl et tar pour le téléchargement/extraction
RUN apt-get update && apt-get install -y curl tar gzip && rm -rf /var/lib/apt/lists/*

# Créer les dossiers nécessaires
RUN mkdir -p /data /logs /defaults

# Copier les fichiers de dépendances et installer
COPY package*.json ./
RUN npm install

# Copier le code source
COPY . .

# Copier le fichier de config par défaut
COPY config.default.json /defaults/config.json

# Build de l'application
RUN npm run build

# Script d'initialisation
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 48733

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "--expose-gc", "build/armory/main.js"]  # ← Changement ici
