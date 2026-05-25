package sk.uniza.fri.alfri.infrastructure.dto;

import java.util.Map;
import java.util.List;

public class PassingChanceRequestDto {
    private Map<String, List<Double>> subjects;

    public Map<String, List<Double>> getSubjects() {
        return subjects;
    }

    public void setSubjects(Map<String, List<Double>> subjects) {
        this.subjects = subjects;
    }
}

