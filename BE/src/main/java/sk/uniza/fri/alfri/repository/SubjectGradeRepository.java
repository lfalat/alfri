package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.SubjectGrade;

import java.util.Optional;

public interface SubjectGradeRepository extends JpaRepository<SubjectGrade, Integer> {

    Optional<Page<SubjectGrade>> findAllByOrderByGradeAverageAsc(Pageable pageable);

    Optional<Page<SubjectGrade>> findAllByOrderByGradeAverageDesc(Pageable pageable);

    Optional<Page<SubjectGrade>> findAllByOrderByGradeADesc(Pageable pageable);

    Optional<Page<SubjectGrade>> findAllByOrderByGradeFxDesc(Pageable pageable);
}

