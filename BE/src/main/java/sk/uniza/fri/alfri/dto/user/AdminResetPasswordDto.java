package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AdminResetPasswordDto {

    @NotBlank(message = "Password cannot be null or blank!")
    String newPassword;
}
