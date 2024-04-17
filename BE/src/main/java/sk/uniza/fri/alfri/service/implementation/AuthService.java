package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;
import sk.uniza.fri.alfri.repository.UserRepository;
import sk.uniza.fri.alfri.service.IAuthService;

/** Created by petos on 17/04/2024. */
@Slf4j
@Service
public class AuthService implements IAuthService {

  private final UserRepository userRepository;

  private final PasswordEncoder passwordEncoder;

  private final AuthenticationManager authenticationManager;

  public AuthService(
      UserRepository userRepository,
      PasswordEncoder passwordEncoder,
      AuthenticationManager authenticationManager) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
    this.authenticationManager = authenticationManager;
  }

  @Override
  public User registerUser(User userToRegister) throws UserAlreadyRegisteredException {

    log.info("Trying to register user with email {}", userToRegister.getEmail());

    String userToRegisterUsername = userToRegister.getUsername();
    if (userRepository.findByEmail(userToRegister.getEmail()).isPresent()) {
      throw new UserAlreadyRegisteredException(
          String.format(
              "User with username %s or email %s is already registered!",
              userToRegisterUsername, userToRegister.getEmail()));
    }

    User user =
        User.builder()
            .role(userToRegister.getRole())
            .firstName(userToRegister.getFirstName())
            .lastName(userToRegister.getLastName())
            .password(passwordEncoder.encode(userToRegister.getPassword()))
            .build();

    log.info("User with email {} was registered!", user.getEmail());

    return userRepository.save(user);
  }

  @Override
  public User verifyUser(User userToAutentificate) throws InvalidCredentialsException {
    try {
      authenticationManager.authenticate(
          new UsernamePasswordAuthenticationToken(
              userToAutentificate.getUsername(), userToAutentificate.getPassword()));
    } catch (AuthenticationException e) {
      log.info("User with email {} was not authenticated!", userToAutentificate.getEmail());
      throw new InvalidCredentialsException("Invalid credentials!");
    }

    return userRepository
        .findByEmail(userToAutentificate.getEmail())
        .orElseThrow(
            () ->
                new EntityNotFoundException(
                    String.format(
                        "Cannot authenticate user with email %s",
                        userToAutentificate.getUsername())));
  }
}
