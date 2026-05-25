package sk.uniza.fri.alfri.dto.datareport;

import java.io.Serializable;
import java.util.Map;

/**
 * DTO for student enrollment trends over academic years
 * Contains a year and a map of study program IDs to student counts
 */
public record StudentTrendDataPoint(
        Integer year,
        Map<Integer, Integer> programCounts
) implements Serializable {
}

