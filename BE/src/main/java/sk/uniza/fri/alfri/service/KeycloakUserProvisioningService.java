package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.dto.keycloak.KeycloakUserRegistrationEventDto;
import sk.uniza.fri.alfri.entity.User;

public interface KeycloakUserProvisioningService {
    User provisionUser(KeycloakUserRegistrationEventDto event);
}
