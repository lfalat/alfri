package sk.uniza.fri.alfri.service.implementation;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
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
      int studyProgramId, int pageNumber, int pageSize) {
    Pageable page = PageRequest.of(pageNumber, pageSize);
    return studyProgramSubjectRepository.findAllById_StudyProgram_Id(studyProgramId, page);
  }
}
