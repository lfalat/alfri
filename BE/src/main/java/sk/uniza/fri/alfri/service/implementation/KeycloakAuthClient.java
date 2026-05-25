package sk.uniza.fri.alfri.service.implementation;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClient;
import sk.uniza.fri.alfri.configuration.KeycloakProperties;
import sk.uniza.fri.alfri.dto.UserRoles;
import sk.uniza.fri.alfri.dto.user.KeycloakTokenResponseDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class KeycloakAuthClient {
    private final RestClient restClient;
    private final KeycloakProperties keycloakProperties;
    private final boolean validateConnectivityOnStartup;

    public KeycloakAuthClient(RestClient.Builder restClientBuilder,
                              KeycloakProperties keycloakProperties,
                              @Value("${keycloak.validate-connectivity-on-startup:true}")
                              boolean validateConnectivityOnStartup) {
        this.restClient = restClientBuilder.build();
        this.keycloakProperties = keycloakProperties;
        this.validateConnectivityOnStartup = validateConnectivityOnStartup;
    }

    @PostConstruct
    public void verifyKeycloakConnectivity() {
        if (!validateConnectivityOnStartup) {
            log.info("Skipping Keycloak connectivity startup validation");
            return;
        }
        String healthUrl = keycloakProperties.healthReadyUri();
        log.info("Verifying Keycloak connectivity at {}", healthUrl);
        restClient.get()
                .uri(healthUrl)
                .retrieve()
                .toBodilessEntity();
        log.info("Keycloak is reachable and ready");
    }

    public KeycloakTokenResponseDto authenticate(String email, String password) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("grant_type", "password");
        form.add("client_id", keycloakProperties.clientId());
        form.add("username", email);
        form.add("password", password);

        try {
            return restClient.post()
                    .uri(keycloakProperties.tokenUri())
                    .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                    .body(form)
                    .retrieve()
                    .body(KeycloakTokenResponseDto.class);
        } catch (HttpClientErrorException.Unauthorized | HttpClientErrorException.BadRequest e) {
            throw new InvalidCredentialsException("Invalid credentials!");
        }
    }

    /**
     * Verifies user credentials via the realm's admin-cli client, which has Direct Access Grants
     * enabled by default. The main app client (alfri-app) uses the browser PKCE flow and does not
     * support password grant, so it cannot be used for credential verification.
     */
    public void verifyUserCredentials(String email, String password) {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("grant_type", "password");
        form.add("client_id", keycloakProperties.adminClientId());
        form.add("username", email);
        form.add("password", password);

        try {
            restClient.post()
                    .uri(keycloakProperties.tokenUri())
                    .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                    .body(form)
                    .retrieve()
                    .toBodilessEntity();
        } catch (HttpClientErrorException.Unauthorized | HttpClientErrorException.BadRequest e) {
            throw new InvalidCredentialsException("Incorrect old password!");
        }
    }

    public void registerUser(User user, String rawPassword) {
        String adminToken = getAdminToken();

        Map<String, Object> body = Map.of(
                "username", user.getEmail(),
                "email", user.getEmail(),
                "firstName", user.getFirstName(),
                "lastName", user.getLastName(),
                "enabled", true,
                "emailVerified", true,
                "credentials", List.of(Map.of(
                        "type", "password",
                        "value", rawPassword,
                        "temporary", false
                ))
        );

        try {
            restClient.post()
                    .uri(keycloakProperties.usersUri())
                    .header(HttpHeaders.AUTHORIZATION, "Bearer " + adminToken)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body)
                    .retrieve()
                    .onStatus(HttpStatusCode::is4xxClientError, (request, response) -> {
                        if (response.getStatusCode().value() == 409) {
                            throw new UserAlreadyRegisteredException(
                                    String.format("User with email %s is already registered!", user.getEmail()));
                        }
                    })
                    .toBodilessEntity();
        } catch (HttpClientErrorException.Conflict e) {
            throw new UserAlreadyRegisteredException(
                    String.format("User with email %s is already registered!", user.getEmail()));
        }

        assignRealmRole(adminToken, user.getEmail(), UserRoles.STUDENT.name());
    }

    public void resetUserPassword(String email, String newPassword) {
        String adminToken = getAdminToken();
        String keycloakUserId = findUserId(adminToken, email);

        Map<String, Object> credential = Map.of(
                "type", "password",
                "value", newPassword,
                "temporary", false
        );

        restClient.put()
                .uri(keycloakProperties.resetPasswordUri(keycloakUserId))
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .body(credential)
                .retrieve()
                .toBodilessEntity();

        log.info("Reset password for Keycloak user with email {}", email);
    }

    private String getAdminToken() {
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("grant_type", "password");
        form.add("client_id", keycloakProperties.adminClientId());
        form.add("username", keycloakProperties.adminUsername());
        form.add("password", keycloakProperties.adminPassword());

        KeycloakTokenResponseDto tokenResponse = restClient.post()
                .uri(keycloakProperties.adminTokenUri())
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(form)
                .retrieve()
                .body(KeycloakTokenResponseDto.class);

        if (tokenResponse == null || tokenResponse.accessToken() == null) {
            throw new IllegalStateException("Keycloak admin token response did not contain an access token");
        }

        return tokenResponse.accessToken();
    }

    private void assignRealmRole(String adminToken, String email, String roleName) {
        String userId = findUserId(adminToken, email);
        Map<String, Object> role = findRealmRole(adminToken, roleName);

        restClient.post()
                .uri(keycloakProperties.userRealmRoleMappingsUri(userId))
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + adminToken)
                .contentType(MediaType.APPLICATION_JSON)
                .body(List.of(role))
                .retrieve()
                .toBodilessEntity();
    }

    @SuppressWarnings("unchecked")
    private String findUserId(String adminToken, String email) {
        List<Map<String, Object>> users = restClient.get()
                .uri(keycloakProperties.usersUri() + "?email={email}&exact=true", email)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + adminToken)
                .retrieve()
                .body(List.class);

        if (users == null || users.isEmpty()) {
            throw new EntityNotFoundException("Keycloak user was not found after creation");
        }

        Object id = users.getFirst().get("id");
        if (!(id instanceof String userId) || userId.isBlank()) {
            throw new EntityNotFoundException("Keycloak user id was not found after creation");
        }

        return userId;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> findRealmRole(String adminToken, String roleName) {
        Map<String, Object> role = restClient.get()
                .uri(keycloakProperties.roleUri(roleName))
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + adminToken)
                .retrieve()
                .body(Map.class);

        if (role == null || role.isEmpty()) {
            throw new EntityNotFoundException("Keycloak role was not found: " + roleName);
        }

        return role;
    }
}
