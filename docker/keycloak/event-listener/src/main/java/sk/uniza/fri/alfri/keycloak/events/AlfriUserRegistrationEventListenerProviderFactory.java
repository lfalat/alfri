package sk.uniza.fri.alfri.keycloak.events;

import org.jboss.logging.Logger;
import org.keycloak.Config;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventListenerProviderFactory;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;

import java.net.URI;
import java.net.http.HttpClient;
import java.time.Duration;

public class AlfriUserRegistrationEventListenerProviderFactory implements EventListenerProviderFactory {
    public static final String PROVIDER_ID = "alfri";

    private static final Logger LOG = Logger.getLogger(AlfriUserRegistrationEventListenerProviderFactory.class);
    private static final String WEBHOOK_URL_ENV = "ALFRI_KEYCLOAK_EVENT_WEBHOOK_URL";
    private static final String WEBHOOK_SECRET_ENV = "ALFRI_KEYCLOAK_EVENT_WEBHOOK_SECRET";

    private URI webhookUri;
    private String webhookSecret;
    private HttpClient httpClient;

    @Override
    public EventListenerProvider create(KeycloakSession session) {
        return new AlfriUserRegistrationEventListenerProvider(session, httpClient, webhookUri, webhookSecret);
    }

    @Override
    public void init(Config.Scope config) {
        String webhookUrl = firstNonBlank(config.get("webhook-url"), config.get("webhookUrl"),
                System.getenv(WEBHOOK_URL_ENV));
        webhookSecret = firstNonBlank(config.get("webhook-secret"), config.get("webhookSecret"),
                System.getenv(WEBHOOK_SECRET_ENV));

        if (webhookUrl == null || webhookUrl.isBlank()) {
            LOG.warnf("ALFRI Keycloak event listener is enabled, but no webhook URL is configured");
        } else {
            webhookUri = URI.create(webhookUrl);
        }

        if (webhookSecret == null || webhookSecret.isBlank()) {
            LOG.warnf("ALFRI Keycloak event listener is enabled, but no webhook secret is configured");
        }

        httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
        // No-op.
    }

    @Override
    public void close() {
        // No-op.
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value;
            }
        }
        return null;
    }
}
