# Étape 1 : Build
FROM node:18-alpine AS build

WORKDIR /app

# Copier les fichiers package
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier tout le code source
COPY . .

# Créer un dossier build même si vide
RUN mkdir -p /app/build && \
    echo "<html><body><h1>CI/CD Site</h1></body></html>" > /app/build/index.html

# Étape 2 : Production
FROM nginx:alpine

# Copier depuis l'étape build
COPY --from=build /app/build /usr/share/nginx/html

# Exposition du port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]