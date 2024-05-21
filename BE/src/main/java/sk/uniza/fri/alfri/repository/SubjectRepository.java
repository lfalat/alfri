package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.Subject;

public interface SubjectRepository {
    Page<Subject> getSubjectsByFilter(PageDefinition pageDefinition, SearchDefinition searchDefinition);
}
