package sk.uniza.fri.alfri.assembler;

import sk.uniza.fri.alfri.dto.user.RoleDto;
import sk.uniza.fri.alfri.dto.user.UserDtoExtended;
import sk.uniza.fri.alfri.entity.User;

import java.util.List;

public class UserAssembler {
    private UserAssembler() {
        // Utility class
    }

    public static UserDtoExtended toUserDtoExtended(User user) {
        if (user == null) {
            return null;
        }

        List<RoleDto> userRoles = user.getUserRoles().stream()
                .map(role -> {
                    RoleDto roleDto = new RoleDto();
                    roleDto.setId(role.getRole().getId());
                    roleDto.setName(role.getRole().getName());
                    return roleDto;
                })
                .toList();

        UserDtoExtended userDto = new UserDtoExtended();
        userDto.setUserId(user.getId());
        userDto.setEmail(user.getEmail());
        userDto.setFirstName(user.getFirstName());
        userDto.setLastName(user.getLastName());
        userDto.setRoles(userRoles);

        return userDto;
    }
}
