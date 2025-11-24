package sk.uniza.fri.alfri.client.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.Map;

@Setter
@Getter
public class PassingMarkResponseDto {
    private String subject;
    private Map<String, Double> distribution;
    private String chosenGrade;
}

