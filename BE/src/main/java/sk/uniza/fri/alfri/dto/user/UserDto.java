package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import lombok.Data;
import lombok.ToString;

/** DTO for {@link sk.uniza.fri.alfri.entity.User} */
@Data
@ToString
public class UserDto {
  Integer userId;

  @NotBlank(message = "First name cannot be null or blank!")
  String firstName;

  @NotBlank(message = "Last name cannot be null or blank!")
  String lastName;

  @NotNull(message = "Role cannot be null!")
  List<RoleDto> roles;

  @Email(message = "Email must have format of email!")
  String email;
}
