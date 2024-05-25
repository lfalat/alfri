package sk.uniza.fri.alfri.service.implementation;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.service.ISubjectService;

@Service
public class SubjectService implements ISubjectService {
  private final StudyProgramSubjectRepository studyProgramSubjectRepository;

  public SubjectService(StudyProgramSubjectRepository studyProgramSubjectRepository) {
    this.studyProgramSubjectRepository = studyProgramSubjectRepository;
  }

  @Override
  public Page<StudyProgramSubject> findAllByStudyProgramId(
      SearchDefinition searchDefinition, PageDefinition pageDefinition) {
    return this.studyProgramSubjectRepository.findAllByFilter(searchDefinition, pageDefinition);
  }
}
