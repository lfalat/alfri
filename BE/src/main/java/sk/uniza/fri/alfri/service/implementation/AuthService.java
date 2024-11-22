package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.user.ChangePasswordDto;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.entity.UserRole;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;
import sk.uniza.fri.alfri.repository.RoleRepository;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.IAuthService;

@Slf4j
@Service
public class AuthService implements IAuthService {

  private final UserRepository userRepository;
  private final RoleRepository roleRepository;

  private final PasswordEncoder passwordEncoder;

  private final AuthenticationManager authenticationManager;

  public AuthService(UserRepository userRepository, RoleRepository roleRepository,
      PasswordEncoder passwordEncoder, AuthenticationManager authenticationManager) {
    this.userRepository = userRepository;
    this.roleRepository = roleRepository;
    this.passwordEncoder = passwordEncoder;
    this.authenticationManager = authenticationManager;
  }

  @Override
  public User registerUser(User userToRegister, List<Integer> rolesIds)
      throws UserAlreadyRegisteredException {
    log.info("Trying to register user with email {}", userToRegister.getEmail());

    // Check if a user with the same email is already registered
    if (userRepository.findByEmail(userToRegister.getEmail()).isPresent()) {
      throw new UserAlreadyRegisteredException(
          String.format("User with email %s is already registered!", userToRegister.getEmail()));
    }

    List<Role> roles = rolesIds.stream().map(roleId -> roleRepository.findById(roleId).orElseThrow(
        () -> new EntityNotFoundException(String.format("Role with id %d was not found", roleId))))
        .toList();

    User user = User.builder().firstName(userToRegister.getFirstName())
        .lastName(userToRegister.getLastName()).email(userToRegister.getEmail())
        .password(passwordEncoder.encode(userToRegister.getPassword())).build();

    List<UserRole> userRoles = roles.stream().map(role -> new UserRole(null, user, role)).toList();
    user.setUserRoles(userRoles);

    log.info("User with email {} was registered!", user.getEmail());

    return userRepository.save(user);
  }

  @Override
  public User verifyUser(User userToAutentificate) throws InvalidCredentialsException {
    try {
      authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
          userToAutentificate.getUsername(), userToAutentificate.getPassword()));
    } catch (AuthenticationException e) {
      log.info("User with email {} was not authenticated!", userToAutentificate.getEmail());
      throw new InvalidCredentialsException("Invalid credentials!");
    }

    return userRepository.findByEmail(userToAutentificate.getEmail())
        .orElseThrow(() -> new EntityNotFoundException(String
            .format("Cannot authenticate user with email %s", userToAutentificate.getUsername())));
  }

  @Override
  public Optional<String> getCurrentUserEmail() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    if (authentication != null && authentication.getPrincipal()instanceof UserDetails userDetails) {
      return Optional.ofNullable(userDetails.getUsername()); // Handle null username
    }
    return Optional.empty();
  }

  @Override
  public void changePassword(ChangePasswordDto changePasswordDto) {
    if (changePasswordDto.getNewPassword().equals(changePasswordDto.getOldPassword())) {
      throw new InvalidCredentialsException(
          String.format("Cannot change password for user with email %s, password are not matching!",
              changePasswordDto.getEmail()));
    }
    User foundUser = this.userRepository.findByEmail(changePasswordDto.getEmail())
        .orElseThrow(() -> new EntityNotFoundException(
            String.format("User with email %s was not found!", changePasswordDto.getEmail())));

    foundUser.setPassword(passwordEncoder.encode(changePasswordDto.getNewPassword()));
    this.userRepository.save(foundUser);
  }
}
