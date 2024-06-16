FROM openjdk:21-jdk

# Add python
RUN microdnf update && \
    microdnf install -y python38 && \
    microdnf clean all

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the host machine to the container
COPY target/alfri-3.2.4.jar app.jar

# Expose the port that the application will run on
EXPOSE 8080

# Set active profile of Spring boot
ENV SPRING_PROFILE_ACTIVE=${SPRING_PROFILE_ACTIVE}

# Command to run the application
ENTRYPOINT ["sh", "-c", "java -jar app.jar --spring.profiles.active=${SPRING_PROFILE_ACTIVE}"]
