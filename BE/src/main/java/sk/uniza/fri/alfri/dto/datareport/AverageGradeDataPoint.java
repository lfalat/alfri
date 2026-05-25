package sk.uniza.fri.alfri.dto.datareport;

import java.io.Serializable;

/**
 * DTO for average grades by academic year and student year level
 */
public record AverageGradeDataPoint(
        Integer academicYear,
        Double year1,
        Double year2,
        Double year3,
        Double year4,
        Double year5
) implements Serializable {
}

