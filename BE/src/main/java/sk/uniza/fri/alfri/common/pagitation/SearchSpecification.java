package sk.uniza.fri.alfri.common.pagitation;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;
import sk.uniza.fri.alfri.exception.BadConditionException;

import java.io.Serial;
import java.util.ArrayList;
import java.util.List;

public class SearchSpecification<T> implements Specification<T> {
    @Serial
    private static final long serialVersionUID = -6650896170916288552L;

    private final List<SearchCriteria> searchCriterias;

    public SearchSpecification(List<SearchCriteria> searchCriterias) {
        this.searchCriterias = searchCriterias;
    }

    @Override
    public Predicate toPredicate(Root<T> root, CriteriaQuery<?> query,
                                 CriteriaBuilder criteriaBuilder) {
        List<Predicate> predicates = new ArrayList<>();

        for (SearchCriteria searchCriteria : this.searchCriterias) {
            String key = searchCriteria.getKey();

            String[] keyParts = key.split("\\.");
            Path<?> fieldPath = root;

            for (String keyPart : keyParts) {
                fieldPath = fieldPath.get(keyPart);
            }

            this.addPredicateFromSearchCriteria(searchCriteria, predicates, criteriaBuilder, fieldPath);
        }
        return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
    }

    private void addPredicateFromSearchCriteria(SearchCriteria searchCriteria,
                                                List<Predicate> predicates, CriteriaBuilder builder, Path<?> fieldPath) {
        switch (searchCriteria.getOperation()) {
            case ">": {
                predicates.add(builder.greaterThanOrEqualTo((Expression<? extends Comparable>) fieldPath,
                        (Comparable) searchCriteria.getFirstValue(fieldPath.getJavaType())));
                break;
            }
            case "<": {
                predicates.add(builder.lessThanOrEqualTo((Expression<? extends Comparable>) fieldPath,
                        (Comparable) searchCriteria.getFirstValue(fieldPath.getJavaType())));
                break;
            }
            case ":": {
                predicates
                        .add(builder.equal(fieldPath, searchCriteria.getFirstValue(fieldPath.getJavaType())));
                break;
            }
            case "~": {
                predicates.add(builder.like(builder.lower((Expression<String>) fieldPath),
                        "%" + searchCriteria.getFirstValue().toLowerCase() + "%"));
                break;
            }
            // TODO test
            case "^": {
                // List of string contains string value.
                predicates.add(builder.isMember(searchCriteria.getFirstValue().toLowerCase(),
                        (Expression<List<String>>) fieldPath));
                break;
            }
            default:
                throw new BadConditionException(
                        "Operation: '" + searchCriteria.getOperation() + "' is not supported.");
        }
    }
}
