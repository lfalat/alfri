package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Value;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;

import java.io.Serializable;
import java.util.List;

/** DTO for {@link sk.uniza.fri.alfri.entity.Teacher} */
@Value
public class TeacherDto implements Serializable {
  @NotNull(message = "Teacher id cannot be null")
  Integer id;

  Integer userId;

  @NotNull(message = "Teacher department cannot be null!")
  DepartmentDto department;

  @NotNull(message = "Teacher subejcts cannot be null!")
  List<SubjectDto> subjects;
}
