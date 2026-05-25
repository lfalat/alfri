package sk.uniza.fri.alfri.dto.keycloak;

import java.util.List;

public record KeycloakUserRegistrationEventDto(String keycloakUserId, String username, String email,
        String firstName, String lastName, List<String> roles) {
}
