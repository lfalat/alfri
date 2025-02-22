package sk.uniza.fri.alfri.service.implementation;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.SubjectGradeCorrelation;
import sk.uniza.fri.alfri.repository.SubjectGradeCorrelationRepository;
import sk.uniza.fri.alfri.service.SubjectGradeCorrelationService;

import java.util.List;

@Service
public class SubjectGradeCorrelationServiceImpl implements SubjectGradeCorrelationService {
    public static final String CORRELATION = "correlation";
    private final SubjectGradeCorrelationRepository subjectGradeCorrelationRepository;

    public SubjectGradeCorrelationServiceImpl(
            SubjectGradeCorrelationRepository subjectGradeCorrelationRepository) {
        this.subjectGradeCorrelationRepository = subjectGradeCorrelationRepository;
    }

    @Override
    public List<SubjectGradeCorrelation> findAll() {
        return subjectGradeCorrelationRepository.findAll();
    }

    @Override
    public List<SubjectGradeCorrelation> findAllWithCorrelation(double correlationTreshold,
                                                                String operator) {
        Specification<SubjectGradeCorrelation> specification;

        switch (operator) {
            case ">" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .gt(root.get(CORRELATION), correlationTreshold);
            case ">=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .greaterThanOrEqualTo(root.get(CORRELATION), correlationTreshold);
            case "<" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .lt(root.get(CORRELATION), correlationTreshold);
            case "<=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .lessThanOrEqualTo(root.get(CORRELATION), correlationTreshold);
            case "=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .equal(root.get(CORRELATION), correlationTreshold);
            case "<>" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder
                    .notEqual(root.get(CORRELATION), correlationTreshold);

            default -> throw new IllegalArgumentException("Invalid operator: " + operator);
        }

        return subjectGradeCorrelationRepository.findAll(specification);
    }
}
