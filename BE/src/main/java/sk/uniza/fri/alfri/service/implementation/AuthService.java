package sk.uniza.fri.alfri.service.implementation;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.IAuthService;

import java.util.Optional;

@Slf4j
@Service
public class AuthService implements IAuthService {

    private final UserRepository userRepository;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public Optional<String> getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails userDetails) {
            return Optional.ofNullable(userDetails.getUsername()); // Handle null username
        }

        if (authentication != null && authentication.getPrincipal() instanceof Jwt jwt) {
            return extractEmail(jwt);
        }

        return Optional.empty();
    }

    @Override
    public Optional<User> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails userDetails) {
            String email = userDetails.getUsername();
            return userRepository.findByEmail(email);
        }

        if (authentication != null && authentication.getPrincipal() instanceof Jwt jwt) {
            return extractEmail(jwt).flatMap(userRepository::findByEmail);
        }

        return Optional.empty();
    }

    private Optional<String> extractEmail(Jwt jwt) {
        String email = jwt.getClaimAsString("email");
        if (email != null && !email.isBlank()) {
            return Optional.of(email);
        }

        String preferredUsername = jwt.getClaimAsString("preferred_username");
        if (preferredUsername != null && !preferredUsername.isBlank()) {
            return Optional.of(preferredUsername);
        }

        return Optional.empty();
    }

}
