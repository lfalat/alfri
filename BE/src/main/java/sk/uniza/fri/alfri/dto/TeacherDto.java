package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;

import java.io.Serializable;
import java.util.List;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.Teacher}
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TeacherDto implements Serializable {
    @NotNull(message = "Teacher id cannot be null")
    Integer id;

    Integer userId;

    @NotNull(message = "Teacher department cannot be null!")
    DepartmentDto department;

    @NotNull(message = "Teacher subejcts cannot be null!")
    List<SubjectDto> subjects;
}
