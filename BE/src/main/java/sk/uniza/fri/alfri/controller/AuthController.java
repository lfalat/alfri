package sk.uniza.fri.alfri.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.uniza.fri.alfri.dto.user.AuthResponseDto;
import sk.uniza.fri.alfri.dto.user.RegisterUserDto;
import sk.uniza.fri.alfri.dto.user.UserCredentialsDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;
import sk.uniza.fri.alfri.mapper.UserMapper;
import sk.uniza.fri.alfri.service.IAuthService;
import sk.uniza.fri.alfri.service.implementation.JwtService;

@RequestMapping("/api/auth")
@RestController
@Slf4j
public class AuthController {
  private final IAuthService authService;
  private final JwtService jwtService;

  public AuthController(IAuthService authService, JwtService jwtService) {
    this.authService = authService;
    this.jwtService = jwtService;
  }

  @PostMapping(
      value = "/authenticate",
      consumes = APPLICATION_JSON_VALUE,
      produces = APPLICATION_JSON_VALUE)
  public ResponseEntity<AuthResponseDto> authenticateUser(
      @RequestBody @Valid UserCredentialsDto credentialsDTO) throws InvalidCredentialsException {
    // Authenticate user
    log.info("AuthentificateUser of user {} started!", credentialsDTO);

    User user = UserMapper.INSTANCE.userCredentialsDtoToUser(credentialsDTO);

    User authenticatedUser;
    authenticatedUser = authService.verifyUser(user);

    // Generate JWT token for the authenticated user
    String token = jwtService.generateToken(authenticatedUser);

    log.info("User {} was authentificated!", user.getUsername());
    return ResponseEntity.ok(new AuthResponseDto(token, jwtService.getExpirationTime()));
  }

  @PostMapping(
      value = "/register",
      consumes = APPLICATION_JSON_VALUE,
      produces = APPLICATION_JSON_VALUE)
  public ResponseEntity<UserDto> register(@RequestBody @Valid RegisterUserDto registerUserDto)
      throws UserAlreadyRegisteredException {
    log.info("Starting registration of user with email {}", registerUserDto.getEmail());
    User userToRegister = UserMapper.INSTANCE.registerUserDtoToUser(registerUserDto);

    User registeredUser = authService.registerUser(userToRegister);

    log.info("User {} was successfuly registered!", registeredUser.getEmail());
    UserDto userDto = UserMapper.INSTANCE.userToUserDto(registeredUser);

    return ResponseEntity.ok(userDto);
  }
}