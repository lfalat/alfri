package sk.uniza.fri.alfri.dto.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RoleDto {
    @NotNull(message = "Role id cannot be null!")
    private Integer id;

    @NotBlank(message = "Role name cannot be null or blank!")
    private String name;
}
