package sk.uniza.fri.alfri.dto.subject;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import sk.uniza.fri.alfri.dto.focus.FocusDTO;

import java.io.Serial;
import java.io.Serializable;

public record SubjectExtendedDto(
        Integer id,
    @Size(max = 100) @NotBlank(message = "Subject's name cannot be blank or null!") String name,
    @Size(max = 50) @NotBlank(message = "Subject's code cannot be blank or null!") String code,
    @NotBlank(message = "Subject's abbreviation cannot be blank or null!") String abbreviation,
    @Size(max = 4) @NotBlank(message = "Subject's obligation cannot be blank or null!")
        String obligation,
        @NotBlank(message = "Subject's study program cannot be null or blank!") String studyProgramName,
        @NotBlank(message = "Subject's study program cannot be null or blank!") String semester,
        @Positive(message = "Subject's recommended year must be positive!") Integer recommendedYear,
        @NotNull(message = "Subject's focus cannot be null!") FocusDTO focusDTO)
        implements Serializable {
    @Serial
    private static final long serialVersionUID = 1626221641618636715L;
}
