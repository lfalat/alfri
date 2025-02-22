package sk.uniza.fri.alfri.controller;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.user.AuthResponseDto;
import sk.uniza.fri.alfri.dto.user.ChangePasswordDto;
import sk.uniza.fri.alfri.dto.user.RegisterUserDto;
import sk.uniza.fri.alfri.dto.user.UserCredentialsDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;
import sk.uniza.fri.alfri.service.IAuthService;
import sk.uniza.fri.alfri.service.implementation.JwtService;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@RequestMapping("/api/auth")
@RestController
@Slf4j
public class AuthController {
    private final IAuthService authService;
    private final JwtService jwtService;
    private final ModelMapper modelMapper;

    public AuthController(IAuthService authService, JwtService jwtService, ModelMapper modelMapper) {
        this.authService = authService;
        this.jwtService = jwtService;
        this.modelMapper = modelMapper;
    }

    @PostMapping(value = "/authenticate", consumes = APPLICATION_JSON_VALUE,
            produces = APPLICATION_JSON_VALUE)
    public ResponseEntity<AuthResponseDto> authenticateUser(
            @RequestBody @Valid UserCredentialsDto credentialsDTO) throws InvalidCredentialsException {
        log.info("AuthenticateUser of user {} started!", credentialsDTO);

        User user = this.modelMapper.map(credentialsDTO, User.class);
        User authenticatedUser = authService.verifyUser(user);
        String token = jwtService.generateToken(authenticatedUser);

        log.info("User {} was authenticated!", user.getUsername());
        return ResponseEntity.ok(new AuthResponseDto(token, jwtService.getExpirationTime()));
    }

    @PostMapping(value = "/register", consumes = APPLICATION_JSON_VALUE,
            produces = APPLICATION_JSON_VALUE)
    public ResponseEntity<UserDto> register(@RequestBody @Valid RegisterUserDto registerUserDto)
            throws UserAlreadyRegisteredException {
        log.info("Starting registration of user with email {}", registerUserDto.getEmail());
        User userToRegister = modelMapper.map(registerUserDto, User.class);

        User registeredUser = authService.registerUser(userToRegister);

        log.info("User {} was successfully registered!", registeredUser.getEmail());
        UserDto userDto = this.modelMapper.map(registeredUser, UserDto.class);

        return ResponseEntity.ok(userDto);
    }

    @PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VISITOR', 'ROLE_VEDENIE'})")
    @PostMapping(value = "/change-password", consumes = APPLICATION_JSON_VALUE)
    public void changePassword(@RequestBody @Valid ChangePasswordDto changePasswordDto)
            throws UserAlreadyRegisteredException {
        log.info("Starting password change of user with email {}", changePasswordDto.getEmail());
        this.authService.changePassword(changePasswordDto);

        log.info("Password for user {} was successfully changed!", changePasswordDto.getEmail());
    }
}
