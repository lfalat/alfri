package sk.uniza.fri.alfri.dto.questionnaire;

import java.util.List;

public record QuestionnaireSectionDTO(String sectionTitle, List<QuestionDTO> questions) {
}
