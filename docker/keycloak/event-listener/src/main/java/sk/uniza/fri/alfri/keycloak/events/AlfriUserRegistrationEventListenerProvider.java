package sk.uniza.fri.alfri.keycloak.events;

import org.jboss.logging.Logger;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventType;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.events.admin.OperationType;
import org.keycloak.events.admin.ResourceType;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.RoleModel;
import org.keycloak.models.UserModel;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Objects;

public class AlfriUserRegistrationEventListenerProvider implements EventListenerProvider {
    private static final Logger LOG = Logger.getLogger(AlfriUserRegistrationEventListenerProvider.class);
    private static final String EVENT_SECRET_HEADER = "X-Keycloak-Event-Secret";

    private final KeycloakSession session;
    private final HttpClient httpClient;
    private final URI webhookUri;
    private final String webhookSecret;

    public AlfriUserRegistrationEventListenerProvider(KeycloakSession session, HttpClient httpClient, URI webhookUri,
            String webhookSecret) {
        this.session = session;
        this.httpClient = httpClient;
        this.webhookUri = webhookUri;
        this.webhookSecret = webhookSecret;
    }

    @Override
    public void onEvent(Event event) {
        if (event.getType() != EventType.REGISTER) {
            return;
        }

        if (webhookUri == null || webhookSecret == null || webhookSecret.isBlank()) {
            LOG.warnf("Skipping ALFRI user provisioning for Keycloak user %s because webhook is not configured",
                    event.getUserId());
            return;
        }

        try {
            UserModel user = resolveUser(event);
            if (user == null) {
                LOG.warnf("Skipping ALFRI user provisioning because Keycloak user %s was not found", event.getUserId());
                return;
            }

            postUserRegistration(user);
        } catch (Exception ex) {
            LOG.errorf(ex, "Failed to send ALFRI user provisioning event for Keycloak user %s", event.getUserId());
        }
    }

    @Override
    public void onEvent(AdminEvent event, boolean includeRepresentation) {
        if (event.getResourceType() != ResourceType.USER || event.getOperationType() != OperationType.CREATE) {
            return;
        }

        if (webhookUri == null || webhookSecret == null || webhookSecret.isBlank()) {
            LOG.warnf("Skipping ALFRI user provisioning for admin-created user because webhook is not configured");
            return;
        }

        try {
            String userId = extractUserIdFromPath(event.getResourcePath());
            if (userId == null) {
                LOG.warnf("Could not extract user ID from admin event resource path: %s", event.getResourcePath());
                return;
            }

            UserModel user = resolveUserById(event.getRealmId(), userId);
            if (user == null) {
                LOG.warnf("Skipping ALFRI user provisioning because admin-created Keycloak user %s was not found",
                        userId);
                return;
            }

            postUserRegistration(user);
        } catch (Exception ex) {
            LOG.errorf(ex, "Failed to send ALFRI user provisioning event for admin-created user from path %s",
                    event.getResourcePath());
        }
    }

    @Override
    public void close() {
        // No-op.
    }

    private UserModel resolveUser(Event event) {
        return resolveUserById(event.getRealmId(), event.getUserId());
    }

    private UserModel resolveUserById(String realmId, String userId) {
        RealmModel realm = session.realms().getRealm(realmId);
        if (realm == null) {
            LOG.warnf("Realm %s was not found while processing ALFRI provisioning event", realmId);
            return null;
        }

        return session.users().getUserById(realm, userId);
    }

    private String extractUserIdFromPath(String resourcePath) {
        if (resourcePath == null) {
            return null;
        }
        // Admin event resource path for user creation is "users/{userId}"
        String[] parts = resourcePath.split("/");
        return (parts.length == 2 && "users".equals(parts[0])) ? parts[1] : null;
    }

    private void postUserRegistration(UserModel user) throws IOException, InterruptedException {
        String payload = toJson(user);
        HttpRequest request = HttpRequest.newBuilder(webhookUri)
                .timeout(Duration.ofSeconds(10))
                .header("Content-Type", "application/json")
                .header(EVENT_SECRET_HEADER, webhookSecret)
                .POST(HttpRequest.BodyPublishers.ofString(payload))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            LOG.warnf("ALFRI user provisioning webhook returned HTTP %d for Keycloak user %s: %s",
                    response.statusCode(), user.getId(), response.body());
            return;
        }

        LOG.infof("ALFRI user provisioning webhook sent for Keycloak user %s", user.getId());
    }

    private String toJson(UserModel user) {
        List<String> roles = user.getRealmRoleMappingsStream().filter(Objects::nonNull).map(RoleModel::getName)
                .sorted().toList();

        return "{"
                + "\"keycloakUserId\":\"" + escape(user.getId()) + "\","
                + "\"username\":\"" + escape(user.getUsername()) + "\","
                + "\"email\":\"" + escape(user.getEmail()) + "\","
                + "\"firstName\":\"" + escape(user.getFirstName()) + "\","
                + "\"lastName\":\"" + escape(user.getLastName()) + "\","
                + "\"roles\":" + rolesToJson(roles)
                + "}";
    }

    private String rolesToJson(List<String> roles) {
        return roles.stream().map(role -> "\"" + escape(role) + "\"")
                .collect(java.util.stream.Collectors.joining(",", "[", "]"));
    }

    private String escape(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder escaped = new StringBuilder(value.length() + 16);
        for (int i = 0; i < value.length(); i++) {
            char currentChar = value.charAt(i);
            switch (currentChar) {
                case '"' -> escaped.append("\\\"");
                case '\\' -> escaped.append("\\\\");
                case '\b' -> escaped.append("\\b");
                case '\f' -> escaped.append("\\f");
                case '\n' -> escaped.append("\\n");
                case '\r' -> escaped.append("\\r");
                case '\t' -> escaped.append("\\t");
                default -> {
                    if (currentChar < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) currentChar));
                    } else {
                        escaped.append(currentChar);
                    }
                }
            }
        }
        return escaped.toString();
    }
}
