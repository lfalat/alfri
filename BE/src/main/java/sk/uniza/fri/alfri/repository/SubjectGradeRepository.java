package sk.uniza.fri.alfri.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.SubjectGrade;

public interface SubjectGradeRepository extends JpaRepository<SubjectGrade, Integer> {
  Optional<Page<SubjectGrade>> findAllByOrderByGradeAverageDesc(Pageable pageable);
}
