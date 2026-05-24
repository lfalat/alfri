package sk.uniza.fri.alfri.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "keycloak")
public record KeycloakProperties(
        String issuerUri,
        String realm,
        String clientId,
        String adminRealm,
        String adminClientId,
        String adminUsername,
        String adminPassword
) {
    public String tokenUri() {
        return issuerUri + "/protocol/openid-connect/token";
    }

    public String adminTokenUri() {
        return issuerUri.replace("/realms/" + realm, "/realms/" + adminRealm)
                + "/protocol/openid-connect/token";
    }

    public String usersUri() {
        return issuerUri.replace("/realms/" + realm, "/admin/realms/" + realm + "/users");
    }

    public String roleUri(String roleName) {
        return issuerUri.replace("/realms/" + realm,
                "/admin/realms/" + realm + "/roles/" + roleName);
    }

    public String userRealmRoleMappingsUri(String userId) {
        return usersUri() + "/" + userId + "/role-mappings/realm";
    }

    public String resetPasswordUri(String keycloakUserId) {
        return usersUri() + "/" + keycloakUserId + "/reset-password";
    }

    public String healthReadyUri() {
        return issuerUri + "/.well-known/openid-configuration";
    }
}
