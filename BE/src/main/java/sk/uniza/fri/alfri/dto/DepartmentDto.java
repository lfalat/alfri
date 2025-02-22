package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.Department}
 */
@NoArgsConstructor
@AllArgsConstructor
@Data
public class DepartmentDto implements Serializable {
    Integer id;

    @NotNull
    @Size(max = 255)
    String name;

    @NotNull
    @Size(max = 10)
    String abbreviation;
}
