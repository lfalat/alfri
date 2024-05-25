package sk.uniza.fri.alfri.service;

import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.Subject;

public interface SubjectService {
  Page<Subject> getSubjects(PageDefinition pageDefinition, SearchDefinition searchCriteria);
}
