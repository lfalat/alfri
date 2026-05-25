# Stage 1: Build the Angular application
FROM node:22 AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Serve the Angular application using Nginx
FROM nginx:alpine

RUN apk add --no-cache gettext

COPY --from=build /app/dist/fe/browser /usr/share/nginx/html
COPY docker-config.template.json /usr/share/nginx/html/assets/config/config.template.json
COPY nginx.conf /etc/nginx/templates/nginx.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
