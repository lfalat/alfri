package sk.uniza.fri.alfri.dto.questionnaire;

import java.util.List;

public record UserFormAnswersDTO(List<AnswerDTO> answers, int formId) {
}
