package sk.uniza.fri.alfri.repository;

import jakarta.persistence.Tuple;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import sk.uniza.fri.alfri.entity.StudentSubject;
import sk.uniza.fri.alfri.entity.StudentSubjectId;

import java.util.List;

@Repository
public interface StudentSubjectRepository extends JpaRepository<StudentSubject, StudentSubjectId> {
    @Query("SELECT s.id.year AS year, COUNT(DISTINCT s.id.studentId) AS studentCount " +
            "FROM StudentSubject s GROUP BY s.id.year")
    List<Tuple> countStudentsByYear();
}
