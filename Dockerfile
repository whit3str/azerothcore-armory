FROM node:16

WORKDIR /app

# Installer tar et gzip pour l'extraction
RUN apt-get update && apt-get install -y tar gzip && rm -rf /var/lib/apt/lists/*

# Créer les dossiers nécessaires
RUN mkdir -p /data /logs /defaults

# Copier les fichiers de dépendances et installer
COPY package*.json ./
RUN npm install

# Copier le code source
COPY . .

# Copier explicitement le dossier static (important !)
COPY static/ ./static/

# Copier le dossier src si nécessaire
COPY src/ ./src/

# Copier le fichier de config par défaut
COPY config.default.json /defaults/config.json

# Build de l'application
RUN npm run build

# Script d'initialisation
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 48733

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
