package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChangePasswordRequestDto {

    @NotBlank(message = "Old password cannot be null or blank!")
    String oldPassword;

    @NotBlank(message = "New password cannot be null or blank!")
    String newPassword;
}
