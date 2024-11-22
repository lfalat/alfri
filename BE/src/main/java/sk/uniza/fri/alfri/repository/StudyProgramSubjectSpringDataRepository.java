package sk.uniza.fri.alfri.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.StudyProgramSubjectId;

public interface StudyProgramSubjectSpringDataRepository
    extends JpaRepository<StudyProgramSubject, StudyProgramSubjectId>,
    JpaSpecificationExecutor<StudyProgramSubject> {
  Optional<StudyProgramSubject> findByIdSubjectId(Integer id);
}
