package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.user.RegisterUserDto;
import sk.uniza.fri.alfri.dto.user.UserCredentialsDto;
import sk.uniza.fri.alfri.dto.user.UserDto;
import sk.uniza.fri.alfri.entity.Role;
import sk.uniza.fri.alfri.entity.User;

@Mapper(componentModel = "spring")
public interface UserMapper {
  UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

  @Mapping(target = "userId", source = "user.id")
  UserDto userToUserDto(User user);

  @Mapping(target = "id", ignore = true)
  @Mapping(source = "registerUserDto.roleId", target = "role")
  @Mapping(target = "student", ignore = true)
  User registerUserDtoToUser(RegisterUserDto registerUserDto);

  @Mapping(target = "password", ignore = true)
  UserCredentialsDto userToUserCredentialsDto(User user);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "role", ignore = true)
  @Mapping(target = "firstName", ignore = true)
  @Mapping(target = "lastName", ignore = true)
  @Mapping(target = "student", ignore = true)
  User userCredentialsDtoToUser(UserCredentialsDto userCredentialsDto);

  default Role mapRoleIdToRole(Integer roleId) {
    if (roleId == null) {
      return null;
    }

    return Mappers.getMapper(RoleMapper.class).mapRoleIdToRole(roleId);
  }
}
