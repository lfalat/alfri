package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.UserMapper;
import sk.uniza.fri.alfri.service.UserService;
import sk.uniza.fri.alfri.service.implementation.JwtService;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@RequestMapping("/api/user")
@RestController
@Slf4j
public class UserController {
    private final JwtService jwtService;
    private final UserService userService;


    public UserController(JwtService jwtService, UserService userService) {
        this.jwtService = jwtService;
        this.userService = userService;
    }

    @GetMapping(
            value = "/profile",
            produces = APPLICATION_JSON_VALUE)

    public UserDto getUser(@RequestHeader(value = "Authorization") String token) {
        String parsedToken = token.replace("Bearer ", "");
        String username = this.jwtService.extractUsername(parsedToken);
        User user = this.userService.getUser(username);
        return UserMapper.INSTANCE.userToUserDto(user);
    }
}
