package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import sk.uniza.fri.alfri.entity.StudyProgram;

/** DTO for {@link StudyProgram} */
public record StudyProgramDto(
    Integer id,
    @Size(max = 100) @NotBlank(message = "StudyProgram's name cannot be blank or null!")
        String name)
    implements Serializable {}
