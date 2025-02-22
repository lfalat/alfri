package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.User}
 */
@Data
public class UserCredentialsDto {
    @NotBlank(message = "Email cannot be null or blank!")
    String email;

    @NotBlank(message = "Password must not be null or blank!")
    String password;
}
