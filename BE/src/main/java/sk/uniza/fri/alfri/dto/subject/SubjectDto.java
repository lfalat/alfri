package sk.uniza.fri.alfri.dto.subject;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.io.Serial;
import java.io.Serializable;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.Subject}
 */
public record SubjectDto(
        @Size(max = 100) @NotBlank(message = "Subject's name cannot be blank or null!") String name,
        @Size(max = 50) @NotBlank(message = "Subject's code cannot be blank or null!") String code,
        @NotBlank(message = "Subject's abbreviation cannot be blank or null!") String abbreviation,
        @Size(max = 4) @NotBlank(message = "Subject's obligation cannot be blank or null!")
        String obligation,
        @NotBlank(message = "Subject's study program cannot be null or blank!") String studyProgramName,
        @NotBlank(message = "Subject's study program cannot be null or blank!") String semester,
        @Positive(message = "Subject's recommended year must be positive!") Integer recommendedYear)
        implements Serializable {
    @Serial
    private static final long serialVersionUID = -463341385819758623L;
}
