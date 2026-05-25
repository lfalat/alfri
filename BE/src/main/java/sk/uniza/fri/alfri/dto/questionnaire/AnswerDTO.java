package sk.uniza.fri.alfri.dto.questionnaire;

import java.util.List;

public record AnswerDTO(int questionId, List<AnswerTextDTO> texts) {
}
