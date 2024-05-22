# Stage 1: Build the Angular application
FROM node:22 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the Angular application using Nginx
FROM nginx:alpine

# Copy the built files from the previous stage to the Nginx container
COPY --from=build app/dist/fe/browser /usr/share/nginx/html

# Expose port 80
EXPOSE 80
