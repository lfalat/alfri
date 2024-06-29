package sk.uniza.fri.alfri.dto.questionnaire;

import java.time.Instant;
import java.util.List;

public record QuestionnaireDTO(int id, String title, String description, List<QuestionnaireSectionDTO> sections,
                               Instant dateOfCreation) {
}
