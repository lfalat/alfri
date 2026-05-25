# Dockerfile.backend
# Builds the Spring Boot app from the BE directory and produces a runnable image.

# Build stage
FROM maven:3.9-eclipse-temurin-26-noble AS build
WORKDIR /app

# Copy only the pom first and download dependencies to leverage Docker cache
COPY pom.xml /app/pom.xml
RUN mvn -B -DskipTests dependency:go-offline

# Copy the rest of the source and build
COPY . /app
RUN mvn -B -DskipTests clean package

# Runtime stage - Java 26 JDK, no Python
FROM eclipse-temurin:26-jdk-noble
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
