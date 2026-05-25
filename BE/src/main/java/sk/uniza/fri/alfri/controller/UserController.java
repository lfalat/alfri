package sk.uniza.fri.alfri.controller;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.assembler.UserAssembler;
import sk.uniza.fri.alfri.dto.user.RoleDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.dto.user.UserDtoExtended;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.RoleMapper;
import sk.uniza.fri.alfri.service.UserService;
import sk.uniza.fri.alfri.service.implementation.AuthService;

import java.util.List;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@RequestMapping("/api/user")
@RestController
@Slf4j
public class UserController {
    private final UserService userService;
    private final AuthService authService;
    private final ModelMapper modelMapper;

    public UserController(UserService userService, AuthService authService, ModelMapper modelMapper) {
        this.userService = userService;
        this.authService = authService;
        this.modelMapper = modelMapper;
    }

    @GetMapping(value = "/profile", produces = APPLICATION_JSON_VALUE)
    public UserDtoExtended getUser() {
        log.info("Loading user profile");
        User user = authService.getCurrentUser()
                .orElseThrow(() -> new EntityNotFoundException("Cannot extract current user"));

        return UserAssembler.toUserDtoExtended(user);
    }

    @GetMapping(value = "/roles", produces = APPLICATION_JSON_VALUE)
    public List<RoleDto> getAllRoles() {
        log.info("Getting all roles");

        List<Role> roles = userService.getRoles();

        log.info("returning {} roles", roles.size());
        return roles.stream().map(RoleMapper.INSTANCE::mapRoleToRoleDto).toList();
    }

    @GetMapping(value = "/currentRoles", produces = APPLICATION_JSON_VALUE)
    public List<RoleDto> getAllCurrentUserRoles() {
        log.info("Getting all users roles");

        User currentUser = authService.getCurrentUser().orElseThrow(
                () -> new AuthenticationCredentialsNotFoundException("Current user was not found"));
        List<Role> roles = currentUser.getUserRoles().stream().map(userRole -> userRole.getRole()).toList();

        return roles.stream().map(RoleMapper.INSTANCE::mapRoleToRoleDto).toList();
    }
}
