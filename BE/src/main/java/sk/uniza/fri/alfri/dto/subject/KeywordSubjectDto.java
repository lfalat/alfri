package sk.uniza.fri.alfri.dto.subject;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

public record KeywordSubjectDto(
        List<SubjectExtendedDto> subjects
        ) {
}
