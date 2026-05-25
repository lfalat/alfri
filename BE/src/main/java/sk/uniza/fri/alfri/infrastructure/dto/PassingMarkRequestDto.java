package sk.uniza.fri.alfri.infrastructure.dto;

import java.util.List;

public class PassingMarkRequestDto {
    private String subject;
    private List<Double> features;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public List<Double> getFeatures() {
        return features;
    }

    public void setFeatures(List<Double> features) {
        this.features = features;
    }
}
