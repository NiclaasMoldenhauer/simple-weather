# Verwende ein Basis-Image mit Node.js, um deine Anwendung auszuführen
FROM node:latest as builder

# Setze das Arbeitsverzeichnis innerhalb des Containers
WORKDIR /app

# Kopiere package.json und package-lock.json in das Arbeitsverzeichnis
COPY package*.json ./

# Installiere Abhängigkeiten
RUN npm install

# Kopiere den Rest deines Codes in das Arbeitsverzeichnis
COPY . .

# Bau deine Vue.js-Anwendung
RUN npm run build

FROM nginx:alpine3.17-slim
COPY --from=builder app/dist /usr/share/nginx/html