package sk.uniza.fri.alfri.dto;

import lombok.Data;

@Data
public class SubjectsPredictionsResult {
    private String subjectName;
    private double passingProbability;
    private String mark;
}
