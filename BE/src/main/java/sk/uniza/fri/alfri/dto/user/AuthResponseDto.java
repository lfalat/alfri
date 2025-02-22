package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponseDto {
    @NotBlank(message = "Jwt token cannot be blank!")
    String jwtToken;

    @NotBlank(message = "Jwt token cannot be blank!")
    long expiresIn;
}
