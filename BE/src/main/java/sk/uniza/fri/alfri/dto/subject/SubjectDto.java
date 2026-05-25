package sk.uniza.fri.alfri.dto.subject;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import sk.uniza.fri.alfri.entity.Subject;

import java.io.Serial;
import java.io.Serializable;

/**
 * DTO for {@link Subject}
 */
//TODO: refactor
@Data
@AllArgsConstructor
@NoArgsConstructor
public final class SubjectDto implements Serializable {
    @Serial
    private static final long serialVersionUID = -463341385819758623L;
    private Integer id;
  private @Size(max = 100)
    @NotBlank(
            message = "Subject's name cannot be blank or null!") String name;
    private @Size(max = 50)
    @NotBlank(
            message = "Subject's code cannot be blank or null!") String code;
    private @NotBlank(
            message = "Subject's abbreviation cannot be blank or null!") String abbreviation;
    private @Size(max = 4)
    @NotBlank(
            message = "Subject's obligation cannot be blank or null!") String obligation;
    private @NotBlank(
            message = "Subject's study program cannot be null or blank!") String studyProgramName;
    private @NotBlank(message = "Subject's study program cannot be null or blank!") String semester;
    private @Positive(
            message = "Subject's recommended year must be positive!") Integer recommendedYear;
    private Long studentCount;

    @Override
    public String toString() {
        return "SubjectDto[" + "name=" + name + ", " + "code=" + code + ", " + "abbreviation="
                + abbreviation + ", " + "obligation=" + obligation + ", " + "studyProgramName="
                + studyProgramName + ", " + "semester=" + semester + ", " + "recommendedYear="
                + recommendedYear + ", " + "studentCount=" + studentCount + ']';
    }
}
