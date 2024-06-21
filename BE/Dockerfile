FROM maven:3.9.6-sapmachine-21

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the host machine to the container
COPY target/alfri-3.2.4.jar app.jar

# Expose the port that the application will run on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["sh", "-c", "java -jar app.jar"]