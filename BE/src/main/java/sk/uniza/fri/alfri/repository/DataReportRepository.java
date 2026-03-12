package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.repository.projection.*;

import java.util.List;

/**
 * Repository for data report queries
 */
@Repository
public interface DataReportRepository extends JpaRepository<Student, Integer> {

    /**
     * Count total number of students
     * @param studyProgramId optional study program filter
     * @return count of students
     */
    @Query("SELECT COUNT(DISTINCT s.id) FROM Student s " +
            "WHERE :studyProgramId IS NULL OR s.studyProgramId = :studyProgramId")
    Long countStudents(@Param("studyProgramId") Integer studyProgramId);

    /**
     * Count total number of subjects
     * @param studyProgramId optional study program filter
     * @return count of subjects
     */
    @Query("SELECT COUNT(DISTINCT sps.subject.id) FROM StudyProgramSubject sps " +
            "WHERE :studyProgramId IS NULL OR sps.studyProgram.id = :studyProgramId")
    Long countSubjects(@Param("studyProgramId") Integer studyProgramId);

    /**
     * Count total number of study programs
     * @param studyProgramId optional study program filter
     * @return count of study programs
     */
    @Query("SELECT COUNT(DISTINCT sp.id) FROM StudyProgram sp " +
            "WHERE :studyProgramId IS NULL OR sp.id = :studyProgramId")
    Long countStudyPrograms(@Param("studyProgramId") Integer studyProgramId);

    /**
     * Get student trend data - count of students by enrollment year and study program
     * @param studyProgramId optional study program filter
     * @param startYear starting enrollment year for historical data
     * @return list of student trend projections
     */
    @Query("SELECT s.enrollmentYear as calendarYear, " +
            "s.studyProgramId as studyProgramId, " +
            "COUNT(DISTINCT s.id) as count " +
            "FROM Student s " +
            "WHERE (:studyProgramId IS NULL OR s.studyProgramId = :studyProgramId) " +
            "AND s.enrollmentYear >= :startYear " +
            "GROUP BY s.enrollmentYear, s.studyProgramId " +
            "ORDER BY s.enrollmentYear, s.studyProgramId")
    List<StudentTrendProjection> getStudentTrendByYear(@Param("studyProgramId") Integer studyProgramId,
                                          @Param("startYear") Integer startYear);

    /**
     * Get students count by their current year level (1-3) and finished (4+)
     * @param studyProgramId optional study program filter
     * @return list of students per year projections
     */
    @Query("SELECT CASE WHEN s.year > 3 THEN 4 ELSE s.year END as year, COUNT(s.id) as count " +
            "FROM Student s " +
            "WHERE :studyProgramId IS NULL OR s.studyProgramId = :studyProgramId " +
            "GROUP BY CASE WHEN s.year > 3 THEN 4 ELSE s.year END " +
            "ORDER BY CASE WHEN s.year > 3 THEN 4 ELSE s.year END")
    List<StudentsPerYearProjection> getStudentsPerYear(@Param("studyProgramId") Integer studyProgramId);

    /**
     * Get average grades by calendar year and student year level
     * Converts letter grades to numeric: A=1.0, B=1.5, C=2.0, D=2.5, E=3.0, FX excluded
     * @param studyProgramId optional study program filter
     * @param startYear starting calendar year for historical data
     * @return list of average grade projections
     */
    @Query("SELECT ss.calendarYear as calendarYear, ss.year as studentYearLevel, " +
            "AVG(CASE " +
            "  WHEN UPPER(ss.mark) = 'A' THEN 1.0 " +
            "  WHEN UPPER(ss.mark) = 'B' THEN 1.5 " +
            "  WHEN UPPER(ss.mark) = 'C' THEN 2.0 " +
            "  WHEN UPPER(ss.mark) = 'D' THEN 2.5 " +
            "  WHEN UPPER(ss.mark) = 'E' THEN 3.0 " +
            "  ELSE NULL END) as avgGrade " +
            "FROM StudentSubject ss " +
            "JOIN Student s ON ss.studentId = s.id " +
            "WHERE (:studyProgramId IS NULL OR s.studyProgramId = :studyProgramId) " +
            "AND UPPER(ss.mark) IN ('A', 'B', 'C', 'D', 'E') " +
            "AND ss.calendarYear >= :startYear " +
            "GROUP BY ss.calendarYear, ss.year " +
            "ORDER BY ss.calendarYear, ss.year")
    List<AverageGradeProjection> getAverageGradesByYearAndStudentYear(@Param("studyProgramId") Integer studyProgramId,
                                                          @Param("startYear") Integer startYear);

    /**
     * Get grade distribution across all students
     * @param studyProgramId optional study program filter
     * @return list of grade distribution projections
     */
    @Query("SELECT UPPER(ss.mark) as grade, COUNT(ss) as count " +
            "FROM StudentSubject ss " +
            "JOIN Student s ON ss.studentId = s.id " +
            "WHERE (:studyProgramId IS NULL OR s.studyProgramId = :studyProgramId) " +
            "AND ss.mark IS NOT NULL " +
            "AND (UPPER(ss.mark) IN ('A', 'B', 'C', 'D', 'E', 'FX') OR ss.mark IN ('A', 'B', 'C', 'D', 'E', 'FX', 'Fx')) " +
            "GROUP BY UPPER(ss.mark) " +
            "ORDER BY CASE UPPER(ss.mark) " +
            "  WHEN 'A' THEN 1 " +
            "  WHEN 'B' THEN 2 " +
            "  WHEN 'C' THEN 3 " +
            "  WHEN 'D' THEN 4 " +
            "  WHEN 'E' THEN 5 " +
            "  WHEN 'FX' THEN 6 " +
            "  ELSE 7 END")
    List<GradeDistributionProjection> getGradeDistribution(@Param("studyProgramId") Integer studyProgramId);

    /**
     * Get all study programs (id and name mapping)
     * @return list of study program projections
     */
    @Query("SELECT sp.id as id, sp.name as name FROM StudyProgram sp")
    List<StudyProgramProjection> getAllStudyPrograms();
}

