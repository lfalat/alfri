package sk.uniza.fri.alfri.service;

import java.io.IOException;
import java.util.List;
import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;

public interface ISubjectService {
  Page<StudyProgramSubject> findAllByStudyProgramId(
      SearchDefinition searchDefinition, PageDefinition pageDefinition);

  Subject findBySubjectCode(String subjectCode);

  List<StudyProgramSubject> getSimilarSubjects(List<Subject> originalSubjects) throws IOException;

  List<StudyProgramSubject> findSubjectByIds(List<Integer> ids);
}
