package sk.uniza.fri.alfri.repository;

import jakarta.persistence.Tuple;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import sk.uniza.fri.alfri.entity.StudentSubject;

import java.util.List;

@Repository
public interface StudentSubjectRepository extends JpaRepository<StudentSubject, StudentSubject.StudentSubjectPK> {
    @Query("SELECT s.year AS year, COUNT(DISTINCT s.studentId) AS studentCount " +
            "FROM StudentSubject s GROUP BY s.year")
    List<Tuple> countStudentsByYear();

    @Query("SELECT s.calendarYear AS year, " +
            "AVG(CASE " +
            "  WHEN UPPER(s.mark) = 'A' THEN 1.0 " +
            "  WHEN UPPER(s.mark) = 'B' THEN 1.5 " +
            "  WHEN UPPER(s.mark) = 'C' THEN 2.0 " +
            "  WHEN UPPER(s.mark) = 'D' THEN 2.5 " +
            "  WHEN UPPER(s.mark) = 'E' THEN 3.0 " +
            "  WHEN UPPER(s.mark) = 'FX' THEN 4.0 " +
            "  ELSE NULL END) AS averageGrade, " +
            "COUNT(DISTINCT s.studentId) AS studentCount " +
            "FROM StudentSubject s " +
            "WHERE s.subjectId = :subjectId " +
            "AND s.mark IS NOT NULL " +
            "AND UPPER(s.mark) IN ('A', 'B', 'C', 'D', 'E', 'FX') " +
            "GROUP BY s.calendarYear " +
            "ORDER BY s.calendarYear")
    List<Tuple> findGradeAverageBySubjectIdGroupedByYear(@Param("subjectId") Integer subjectId);
}
