package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.keycloak.KeycloakUserRegistrationEventDto;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;
import sk.uniza.fri.alfri.repository.RoleRepository;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.KeycloakUserProvisioningService;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Slf4j
@Service
public class KeycloakUserProvisioningServiceImpl implements KeycloakUserProvisioningService {
    private static final String DEFAULT_ROLE = "STUDENT";
    private static final String KEYCLOAK_MANAGED_PASSWORD_PLACEHOLDER = "KEYCLOAK_MANAGED";

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public KeycloakUserProvisioningServiceImpl(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    @Override
    @Transactional
    public User provisionUser(KeycloakUserRegistrationEventDto event) {
        String email = normalizedEmail(event);
        List<Role> roles = resolveRoles(event.roles());

        User user = userRepository.findByEmail(email).orElseGet(() -> createUser(event, email));
        updateProfileFields(user, event, email);
        addMissingRoles(user, roles);

        User savedUser = userRepository.save(user);
        log.info("Provisioned local user profile for Keycloak user {} with email {}", event.keycloakUserId(), email);
        return savedUser;
    }

    private String normalizedEmail(KeycloakUserRegistrationEventDto event) {
        String email = event.email();
        if (email == null || email.isBlank()) {
            email = event.username();
        }

        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Keycloak registration event does not contain email or username");
        }

        return email.trim().toLowerCase(Locale.ROOT);
    }

    private List<Role> resolveRoles(List<String> eventRoles) {
        Set<String> roleNames = new LinkedHashSet<>();

        if (eventRoles != null) {
            eventRoles.stream()
                    .filter(role -> role != null && !role.isBlank())
                    .map(this::normalizeRoleName)
                    .filter(role -> !role.startsWith("DEFAULT-ROLES-"))
                    .filter(role -> !"OFFLINE_ACCESS".equals(role))
                    .filter(role -> !"UMA_AUTHORIZATION".equals(role))
                    .forEach(roleNames::add);
        }

        if (roleNames.isEmpty()) {
            roleNames.add(DEFAULT_ROLE);
        }

        return roleNames.stream().map(roleName -> roleRepository.findByName(roleName.toLowerCase())
                .orElseThrow(() -> new EntityNotFoundException("Role " + roleName + " was not found"))).toList();
    }

    private String normalizeRoleName(String role) {
        String normalizedRole = role.trim().toUpperCase(Locale.ROOT);
        if (normalizedRole.startsWith("ROLE_")) {
            return normalizedRole.substring("ROLE_".length());
        }
        return normalizedRole;
    }

    private User createUser(KeycloakUserRegistrationEventDto event, String email) {
        User user = new User();
        user.setEmail(email);
        user.setFirstName(firstNonBlank(event.firstName(), email));
        user.setLastName(firstNonBlank(event.lastName(), "-"));
        user.setPassword(KEYCLOAK_MANAGED_PASSWORD_PLACEHOLDER);
        user.setUserRoles(new ArrayList<>());
        return user;
    }

    private void updateProfileFields(User user, KeycloakUserRegistrationEventDto event, String email) {
        user.setEmail(email);
        user.setFirstName(firstNonBlank(event.firstName(), user.getFirstName(), email));
        user.setLastName(firstNonBlank(event.lastName(), user.getLastName(), "-"));
        user.setPassword(firstNonBlank(user.getPassword(), KEYCLOAK_MANAGED_PASSWORD_PLACEHOLDER));

        if (user.getUserRoles() == null) {
            user.setUserRoles(new ArrayList<>());
        }
    }

    private void addMissingRoles(User user, List<Role> roles) {
        Set<Integer> currentRoleIds = user.getUserRoles().stream()
                .filter(userRole -> userRole.getRole() != null)
                .map(userRole -> userRole.getRole().getId())
                .collect(java.util.stream.Collectors.toSet());

        for (Role role : roles) {
            if (currentRoleIds.add(role.getId())) {
                user.getUserRoles().add(UserRole.builder().user(user).role(role).build());
            }
        }
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return "-";
    }
}
