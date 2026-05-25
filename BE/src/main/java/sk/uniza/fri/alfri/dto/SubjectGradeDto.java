package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotNull;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;

import java.io.Serializable;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.SubjectGrade}
 */
public record SubjectGradeDto(
        Integer id,
        SubjectDto subject,
        @NotNull Float gradeA,
        @NotNull Float gradeB,
        @NotNull Float gradeC,
        @NotNull Float gradeD,
        @NotNull Float gradeE,
        @NotNull Float gradeFx,
        @NotNull Integer studentsCount,
        @NotNull Float gradeAverage)
        implements Serializable {
}
