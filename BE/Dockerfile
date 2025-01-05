#
# STAGE 1: BUILD THE SPRING BOOT APPLICATION
#
FROM maven:3.9.6-sapmachine-21 AS build

WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:go-offline

COPY . /app
RUN mvn clean package -DskipTests

#
# STAGE 2: CREATE THE FINAL IMAGE
#
FROM openjdk:21-jdk-slim

WORKDIR /app

COPY --from=build /app/target/alfri-3.3.3.jar /app/app.jar

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools && \
    /opt/venv/bin/pip install joblib numpy scikit-learn==1.5.0 tensorflow==2.12.0

COPY python_scripts /app/python_scripts

ENV PATH="/opt/venv/bin:$PATH"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
