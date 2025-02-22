package sk.uniza.fri.alfri.dto.questionnaire;

import java.util.List;

public record QuestionnaireSectionDTO(String sectionTitle, String sectionDescription, List<QuestionDTO> questions,
                                      boolean shouldFetchData) {
}
