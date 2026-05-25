# Dockerfile.backend
# Builds the Spring Boot app from the BE directory and produces a runnable image.

# Build stage
FROM maven:3.9.6-sapmachine-21 AS build
WORKDIR /app

# Copy only the pom first and download dependencies to leverage Docker cache and avoid repeated downloads
COPY pom.xml /app/pom.xml
RUN mvn -B -DskipTests dependency:go-offline

# Copy the rest of the source and build
COPY . /app
RUN mvn -B -DskipTests clean package

# Final runtime image
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Install minimal python runtime & build tooling required by some of the python model deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-venv curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a virtualenv and preinstall lightweight ML runtime deps used by the application
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip setuptools \
    && /opt/venv/bin/pip install --no-cache-dir joblib numpy scikit-learn==1.5.0

ENV PATH="/opt/venv/bin:$PATH"

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar /app/app.jar

# Copy python helper scripts from the build stage (they were added to /app in the build stage)
COPY --from=build /app/python_scripts /app/python_scripts

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
