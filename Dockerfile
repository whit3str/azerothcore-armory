FROM node:16

WORKDIR /app

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Créer les dossiers nécessaires
RUN mkdir -p /data /logs /defaults /app/data-template

# Copier les fichiers de dépendances et installer
COPY package*.json ./
RUN npm install

# Copier le code source
COPY . .

# Copier les fichiers CSV existants vers le template
COPY data/ /app/data-template/

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
