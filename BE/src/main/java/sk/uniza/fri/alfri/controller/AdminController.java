package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.RoleUpdateRequestDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.service.AdminService;
import sk.uniza.fri.alfri.service.UserService;

import java.util.List;

/** Created by petos on 11/19/24. */
@RestController
@Slf4j
@RequestMapping("/api/admin/")
@PreAuthorize("hasRole('ROLE_ADMIN')")
public class AdminController {
  private final ModelMapper modelMapper;
  private final UserService userService;
  private final AdminService adminService;

  public AdminController(UserService userService, ModelMapper modelMapper,
      AdminService adminService) {
    this.userService = userService;
    this.modelMapper = modelMapper;
    this.adminService = adminService;
  }

  @GetMapping("/users")
  public ResponseEntity<List<UserDto>> get() {
    log.info("Getting all users");
    List<User> users = this.userService.getAllUsers();

    List<UserDto> userDtos =
        users.stream().map(user -> modelMapper.map(user, UserDto.class)).toList();
    log.info("Returning {} users", userDtos.size());

    return ResponseEntity.ok(userDtos);
  }

  @PostMapping("/user/{userId}/roles")
  public ResponseEntity<UserDto> addRolesToUser(@PathVariable Integer userId,
      @RequestBody RoleUpdateRequestDto body) {
    if (body.add()) {
      log.info("Adding roles with ids {} to user with id {}", body.roleIds(), userId);
    } else {
      log.info("Removing roles with ids {} to user with id {}", body.roleIds(), userId);
    }

    User updatedUser = this.adminService.changeUserRole(body.roleIds(), body.add(), userId);
    UserDto userDto = this.modelMapper.map(updatedUser, UserDto.class);

    return ResponseEntity.status(HttpStatus.CREATED).body(userDto);
  }

  @DeleteMapping("/user/{userId}")
  public ResponseEntity<Void> deleteUser(@PathVariable Integer userId) {
    log.info("Deleting user with id {}", userId);

    userService.deleteUser(userId);

    return ResponseEntity.ok().build();
  }
}
