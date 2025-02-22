package sk.uniza.fri.alfri.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
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
import sk.uniza.fri.alfri.dto.DepartmentIdRequestDto;
import sk.uniza.fri.alfri.dto.RoleUpdateRequestDto;
import sk.uniza.fri.alfri.dto.TeacherDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.Teacher;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.service.AdminService;
import sk.uniza.fri.alfri.service.TeacherService;
import sk.uniza.fri.alfri.service.UserService;

import java.util.List;

/**
 * Created by petos on 11/19/24.
 */
@RestController
@Slf4j
@Tag(name = "Admin Controller", description = "Controller for the admin page")
@RequestMapping("/api/admin/")
@PreAuthorize("hasRole('ROLE_ADMIN')")
public class AdminController {
    private final ModelMapper modelMapper;
    private final UserService userService;
    private final AdminService adminService;
    private final TeacherService teacherService;

    public AdminController(UserService userService, ModelMapper modelMapper,
                           AdminService adminService, TeacherService teacherService) {
        this.userService = userService;
        this.modelMapper = modelMapper;
        this.adminService = adminService;
        this.teacherService = teacherService;
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

    @PostMapping("/teacher/{userId}/subjects")
    public ResponseEntity<TeacherDto> changeSubjectsOfTeacher(@PathVariable Integer userId,
                                                              @RequestBody List<String> subjectCodes) {
        log.info("Setting subjects {} to teacher with userId {}", subjectCodes.toString(), userId);

        Teacher updatedTeacher = adminService.setSubjectsToTeacherByUserId(userId, subjectCodes);

        TeacherDto teacherDto = this.modelMapper.map(updatedTeacher, TeacherDto.class);

        return ResponseEntity.status(HttpStatus.CREATED).body(teacherDto);
    }

    @PostMapping("/teacher/{userId}/department")
    public ResponseEntity<TeacherDto> changeDepartmentOfTeacher(@PathVariable Integer userId,
                                                                @RequestBody DepartmentIdRequestDto departmentId) {
        log.info("Changing department of teacher with userId {} to department with id {}", userId,
                departmentId);

        Teacher teacher = teacherService.changeDepartment(departmentId.getDepartmentId(), userId);
        TeacherDto teacherDto = modelMapper.map(teacher, TeacherDto.class);

        return ResponseEntity.ok(teacherDto);
    }
}
