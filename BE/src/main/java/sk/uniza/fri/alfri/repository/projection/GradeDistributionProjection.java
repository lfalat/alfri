package sk.uniza.fri.alfri.repository.projection;

/**
 * Projection for grade distribution
 */
public interface GradeDistributionProjection {
    String getGrade();
    Long getCount();
}

