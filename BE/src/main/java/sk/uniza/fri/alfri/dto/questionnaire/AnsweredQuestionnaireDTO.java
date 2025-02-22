package sk.uniza.fri.alfri.dto.questionnaire;

import java.time.Instant;
import java.util.List;

public record AnsweredQuestionnaireDTO(int id, String title, String description,
                                       List<AnsweredQuestionnaireSectionDTO> sections,
                                       Instant dateOfCreation) {
}
