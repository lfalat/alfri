package sk.uniza.fri.alfri.service;

import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

public interface ISubjectService {
  Page<StudyProgramSubject> findAllByStudyProgramId(SearchDefinition searchDefinition, PageDefinition pageDefinition);
}
