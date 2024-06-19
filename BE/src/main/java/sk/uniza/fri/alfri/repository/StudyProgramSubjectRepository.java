package sk.uniza.fri.alfri.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

public interface StudyProgramSubjectRepository {
  Page<StudyProgramSubject> findAllByFilter(
      SearchDefinition searchDefinition, PageDefinition pageDefinition);

  Optional<StudyProgramSubject> findByIdSubjectId(Integer id);
}
