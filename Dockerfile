FROM node:16

# Définir le répertoire de travail
WORKDIR /app

# Installer curl pour télécharger les données
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Créer les dossiers nécessaires
RUN mkdir -p /data /logs /defaults

# Copier les fichiers de dépendances
COPY package*.json ./

# Installation des dépendances
RUN npm install

# Copier tout le code source
COPY . .

# Télécharger les données du model viewer depuis les Releases
# Remplacez l'URL par la dernière version disponible sur GitHub
RUN curl -L -o /tmp/modelviewer-data.zip \
    "https://github.com/r-o-b-o-t-o/azerothcore-armory/releases/latest/download/modelviewer-data.zip" && \
    unzip /tmp/modelviewer-data.zip -d /app/data-template/ && \
    rm /tmp/modelviewer-data.zip

# Copier les fichiers CSV et images existants
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
