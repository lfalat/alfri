package sk.uniza.fri.alfri.client.dto;

import java.util.Map;

public class PassingChanceResponseDto {
    private Map<String, ProbabilityResultDto> results;

    public Map<String, ProbabilityResultDto> getResults() {
        return results;
    }

    public void setResults(Map<String, ProbabilityResultDto> results) {
        this.results = results;
    }
}

