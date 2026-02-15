package sk.uniza.fri.alfri.client.dto;

public class ProbabilityResultDto {
    private double probability;
    private String percentage;

    public double getProbability() {
        return probability;
    }

    public void setProbability(double probability) {
        this.probability = probability;
    }

    public String getPercentage() {
        return percentage;
    }

    public void setPercentage(String percentage) {
        this.percentage = percentage;
    }
}

