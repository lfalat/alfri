package sk.uniza.fri.alfri.repository.projection;

/**
 * Projection for average grades by calendar year and student year level
 */
public interface AverageGradeProjection {
    Integer getCalendarYear();
    Integer getStudentYearLevel();
    Double getAvgGrade();
}

