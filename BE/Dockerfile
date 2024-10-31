# Start with the Maven base image for building the Java application
FROM maven:3.9.6-sapmachine-21 AS build

# Copy the Java Spring Boot project files and build the application
COPY . /app
WORKDIR /app
COPY python_scripts /app/python_scripts
RUN mvn clean package -DskipTests

# Use a lighter JDK base image for running the built application
FROM openjdk:21-jdk-slim

# Install Python (default version for Debian Bookworm) and required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up a Python virtual environment and install Python libraries
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools joblib numpy scikit-learn

# Set the virtual environment as default for Python and pip commands
ENV PATH="/opt/venv/bin:$PATH"

# Copy the built jar file from the build stage
COPY --from=build /app/target/alfri-3.3.3.jar /app/app.jar

# Expose the port for the Spring Boot application
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
