package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.SubjectGrade;

public interface SubjectGradeRepository extends JpaRepository<SubjectGrade, Integer> {

    @Query("SELECT sg FROM SubjectGrade sg WHERE LOWER(sg.subject.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(sg.subject.code) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<SubjectGrade> findBySubjectNameOrCode(@Param("search") String search, Pageable pageable);
}
