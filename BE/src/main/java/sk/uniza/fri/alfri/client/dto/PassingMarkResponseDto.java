package sk.uniza.fri.alfri.client.dto;

import java.util.Map;

public class PassingMarkResponseDto {
    private String subject;
    private Map<String, Double> distribution;
    private String chosen_grade;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Map<String, Double> getDistribution() {
        return distribution;
    }

    public void setDistribution(Map<String, Double> distribution) {
        this.distribution = distribution;
    }

    public String getChosen_grade() {
        return chosen_grade;
    }

    public void setChosen_grade(String chosen_grade) {
        this.chosen_grade = chosen_grade;
    }
}

