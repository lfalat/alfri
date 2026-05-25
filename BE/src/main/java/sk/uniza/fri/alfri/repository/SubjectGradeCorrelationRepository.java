package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import sk.uniza.fri.alfri.entity.SubjectGradeCorrelation;

public interface SubjectGradeCorrelationRepository
        extends JpaRepository<SubjectGradeCorrelation, Integer>,
        JpaSpecificationExecutor<SubjectGradeCorrelation> {
}
