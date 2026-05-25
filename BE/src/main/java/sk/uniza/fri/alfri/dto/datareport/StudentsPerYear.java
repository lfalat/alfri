package sk.uniza.fri.alfri.dto.datareport;

import java.io.Serializable;

/**
 * DTO for student distribution by year level (1-3 and 'Finished' for 4+)
 */
public record StudentsPerYear(
        String year,
        Long count
) implements Serializable {
}

