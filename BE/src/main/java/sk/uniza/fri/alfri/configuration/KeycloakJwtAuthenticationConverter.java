package sk.uniza.fri.alfri.configuration;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Component
public class KeycloakJwtAuthenticationConverter implements Converter<Jwt, AbstractAuthenticationToken> {
    private static final String EMAIL_CLAIM = "email";
    private static final String PREFERRED_USERNAME_CLAIM = "preferred_username";
    private static final String ROLES_CLAIM = "roles";
    private static final String REALM_ACCESS_CLAIM = "realm_access";

    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        return new JwtAuthenticationToken(jwt, extractAuthorities(jwt), extractPrincipalName(jwt));
    }

    private Collection<GrantedAuthority> extractAuthorities(Jwt jwt) {
        Set<GrantedAuthority> authorities = new LinkedHashSet<>();

        addRoles(jwt.getClaim(ROLES_CLAIM), authorities);

        Map<String, Object> realmAccess = jwt.getClaim(REALM_ACCESS_CLAIM);
        if (realmAccess != null) {
            addRoles(realmAccess.get(ROLES_CLAIM), authorities);
        }

        return authorities;
    }

    private void addRoles(Object rolesClaim, Set<GrantedAuthority> authorities) {
        if (rolesClaim instanceof Collection<?> roles) {
            roles.forEach(role -> addRole(role, authorities));
        } else {
            addRole(rolesClaim, authorities);
        }
    }

    private void addRole(Object roleClaim, Set<GrantedAuthority> authorities) {
        if (!(roleClaim instanceof String role) || role.isBlank()) {
            return;
        }

        String normalizedRole = role.trim().toUpperCase(Locale.ROOT);
        String authority = normalizedRole.startsWith("ROLE_")
                ? normalizedRole
                : "ROLE_" + normalizedRole;

        authorities.add(new SimpleGrantedAuthority(authority));
    }

    private String extractPrincipalName(Jwt jwt) {
        String email = jwt.getClaimAsString(EMAIL_CLAIM);
        if (email != null && !email.isBlank()) {
            return email;
        }

        String preferredUsername = jwt.getClaimAsString(PREFERRED_USERNAME_CLAIM);
        if (preferredUsername != null && !preferredUsername.isBlank()) {
            return preferredUsername;
        }

        return jwt.getSubject();
    }
}
