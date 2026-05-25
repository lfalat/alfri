package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChangePasswordDto {

    @Email(message = "Email must have format of email!")
    String email;

    @NotBlank(message = "Password cannot be null or blank!")
    String oldPassword;

    @NotBlank(message = "Password cannot be null or blank!")
    String newPassword;
}
