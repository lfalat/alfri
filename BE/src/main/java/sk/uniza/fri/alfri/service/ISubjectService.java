package sk.uniza.fri.alfri.service;

import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

public interface ISubjectService {
  Page<StudyProgramSubject> findAllByStudyProgramId(
      int studyProgramId, int pageNumber, int pageSize);
}
