package sk.uniza.fri.alfri.dto.questionnaire;

import java.util.List;

public record AnsweredQuestionnaireSectionDTO(String sectionTitle, String sectionDescription,
                                              List<AnsweredQuestionDTO> questions) {
}
