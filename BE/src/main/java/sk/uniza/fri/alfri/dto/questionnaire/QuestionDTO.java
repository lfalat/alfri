package sk.uniza.fri.alfri.dto.questionnaire;


import java.util.List;

public record QuestionDTO(int id, String questionTitle, AnswerType answerType,
                          boolean optional, List<QuestionOptionDTO> options, int positionInQuestionnaire,
                          String questionIdentifier) {
}
