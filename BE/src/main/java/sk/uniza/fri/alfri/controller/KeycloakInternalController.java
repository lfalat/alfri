package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import sk.uniza.fri.alfri.dto.keycloak.KeycloakUserRegistrationEventDto;
import sk.uniza.fri.alfri.service.KeycloakUserProvisioningService;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@Slf4j
@RestController
@RequestMapping("/api/internal/keycloak")
public class KeycloakInternalController {
    private static final String EVENT_SECRET_HEADER = "X-Keycloak-Event-Secret";

    private final KeycloakUserProvisioningService provisioningService;
    private final String webhookSecret;

    public KeycloakInternalController(KeycloakUserProvisioningService provisioningService,
            @Value("${keycloak.events.webhook-secret}") String webhookSecret) {
        this.provisioningService = provisioningService;
        this.webhookSecret = webhookSecret;
    }

    @PostMapping("/users")
    public ResponseEntity<Void> provisionRegisteredUser(
            @RequestHeader(name = EVENT_SECRET_HEADER, required = false) String providedSecret,
            @RequestBody KeycloakUserRegistrationEventDto event) {
        verifySecret(providedSecret);
        provisioningService.provisionUser(event);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    private void verifySecret(String providedSecret) {
        if (webhookSecret == null || webhookSecret.isBlank()) {
            log.error("Keycloak event webhook secret is not configured");
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR);
        }

        byte[] expectedSecretBytes = webhookSecret.getBytes(StandardCharsets.UTF_8);
        byte[] providedSecretBytes = providedSecret == null ? new byte[0] : providedSecret.getBytes(
                StandardCharsets.UTF_8);

        if (!MessageDigest.isEqual(expectedSecretBytes, providedSecretBytes)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
    }
}
