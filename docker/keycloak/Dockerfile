FROM maven:3.9.6-sapmachine-21 AS provider-build
WORKDIR /build

COPY docker/keycloak/event-listener/pom.xml ./pom.xml
RUN mvn -B -DskipTests dependency:go-offline

COPY docker/keycloak/event-listener /build
RUN mvn -B -DskipTests package

FROM quay.io/keycloak/keycloak:26.6.2

COPY --from=provider-build /build/target/alfri-keycloak-event-listener-*.jar /opt/keycloak/providers/
