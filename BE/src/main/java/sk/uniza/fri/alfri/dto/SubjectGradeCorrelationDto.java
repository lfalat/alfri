package sk.uniza.fri.alfri.dto;

import jakarta.validation.constraints.NotNull;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;

import java.io.Serializable;

/**
 * DTO for {@link sk.uniza.fri.alfri.entity.SubjectGradeCorrelation}
 */
public record SubjectGradeCorrelationDto(
        @NotNull(message = "first subject cannot be null!") SubjectDto firstSubject,
        @NotNull(message = "second subject cannot be nu;;!") SubjectDto secondSubject,
        @NotNull Double correlation)
        implements Serializable {
}
