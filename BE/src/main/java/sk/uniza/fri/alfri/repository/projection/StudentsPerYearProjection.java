package sk.uniza.fri.alfri.repository.projection;

/**
 * Projection for students count by year level
 */
public interface StudentsPerYearProjection {
    Integer getYear();
    Long getCount();
}

