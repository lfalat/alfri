package sk.uniza.fri.alfri.dto.questionnaire;

import lombok.Getter;

@Getter
public enum AnswerType {
    TEXT(1), NUMERIC(2), RADIO(3), CHECKBOX(4), DROPDOWN(5), GRADE(6);

    private final int id;

    AnswerType(int id) {
        this.id = id;
    }

    public static AnswerType fromId(int id) {
        for (AnswerType type : values()) {
            if (type.getId() == id) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown id: " + id);
    }
}
