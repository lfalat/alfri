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
    public static final String FIRST_SUBJECT = "firstSubject";
    public static final String SECOND_SUBJECT = "secondSubject";
    private final SubjectGradeCorrelationRepository subjectGradeCorrelationRepository;

    public SubjectGradeCorrelationServiceImpl(
            SubjectGradeCorrelationRepository subjectGradeCorrelationRepository) {
        this.subjectGradeCorrelationRepository = subjectGradeCorrelationRepository;
    }

    @Override
    public List<SubjectGradeCorrelation> findAll(Integer studyProgramId) {
        Specification<SubjectGradeCorrelation> specification = (root, query, criteriaBuilder) -> {
            // first ensure subjects are not the same
            var notEqual = criteriaBuilder.notEqual(root.get(FIRST_SUBJECT), root.get(SECOND_SUBJECT));

            if (studyProgramId == null) {
                return notEqual;
            }

            // join from firstSubject -> studyProgramSubjects -> studyProgram -> id
            var firstJoin = root.join(FIRST_SUBJECT).join("studyProgramSubjects");
            var secondJoin = root.join(SECOND_SUBJECT).join("studyProgramSubjects");

            var firstProgramIdPath = firstJoin.get("studyProgram").get("id");
            var secondProgramIdPath = secondJoin.get("studyProgram").get("id");

            var firstEq = criteriaBuilder.equal(firstProgramIdPath, studyProgramId);
            var secondEq = criteriaBuilder.equal(secondProgramIdPath, studyProgramId);

            return criteriaBuilder.and(notEqual, firstEq, secondEq);
        };

        return subjectGradeCorrelationRepository.findAll(specification);
    }

    @Override
    public List<SubjectGradeCorrelation> findAllWithCorrelation(double correlationTreshold,
                                                                String operator, Integer studyProgramId) {
        Specification<SubjectGradeCorrelation> basePredicate = (root, query, criteriaBuilder) -> {
            var notEqual = criteriaBuilder.notEqual(root.get(FIRST_SUBJECT), root.get(SECOND_SUBJECT));

            if (studyProgramId == null) {
                return notEqual;
            }

            var firstJoin = root.join(FIRST_SUBJECT).join("studyProgramSubjects");
            var secondJoin = root.join(SECOND_SUBJECT).join("studyProgramSubjects");

            var firstProgramIdPath = firstJoin.get("studyProgram").get("id");
            var secondProgramIdPath = secondJoin.get("studyProgram").get("id");

            var firstEq = criteriaBuilder.equal(firstProgramIdPath, studyProgramId);
            var secondEq = criteriaBuilder.equal(secondProgramIdPath, studyProgramId);

            return criteriaBuilder.and(notEqual, firstEq, secondEq);
        };

        Specification<SubjectGradeCorrelation> specification;

        switch (operator) {
            case ">" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.gt(root.get(CORRELATION), correlationTreshold),
                    // include base predicates
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );
            case ">=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.greaterThanOrEqualTo(root.get(CORRELATION), correlationTreshold),
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );
            case "<" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.lt(root.get(CORRELATION), correlationTreshold),
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );
            case "<=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.lessThanOrEqualTo(root.get(CORRELATION), correlationTreshold),
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );
            case "=" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.equal(root.get(CORRELATION), correlationTreshold),
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );
            case "<>" -> specification = (root, query, criteriaBuilder) -> criteriaBuilder.and(
                    criteriaBuilder.notEqual(root.get(CORRELATION), correlationTreshold),
                    basePredicate.toPredicate(root, query, criteriaBuilder)
            );

            default -> throw new IllegalArgumentException("Invalid operator: " + operator);
        }

        return subjectGradeCorrelationRepository.findAll(specification);
    }
}
