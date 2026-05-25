package sk.uniza.fri.alfri.dto.datareport;

import java.io.Serializable;

/**
 * DTO for grade distribution across all students
 */
public record GradeDistribution(
        String grade,
        Long count
) implements Serializable {
}

