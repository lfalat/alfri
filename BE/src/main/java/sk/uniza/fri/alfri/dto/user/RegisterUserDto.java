package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.Data;

/** DTO for {@link sk.uniza.fri.alfri.entity.User} */
@Data
public class RegisterUserDto {
  @NotBlank(message = "First name cannot be null or blank!")
  String firstName;

  @NotBlank(message = "Last name cannot be null or blank!")
  String lastName;

  @Positive(message = "Role id must be positive number!")
  Integer roleId;

  @Email(message = "Email must have format of email!")
  String email;

  @NotBlank(message = "Password must not be null or blank!")
  String password;
}
