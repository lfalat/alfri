package sk.uniza.fri.alfri.repository.projection;
/**
 * Projection for student trend data by calendar year and study program
*/

public interface StudentTrendProjection {
    Long getCount();
    Integer getStudyProgramId();
    Integer getCalendarYear();
}


