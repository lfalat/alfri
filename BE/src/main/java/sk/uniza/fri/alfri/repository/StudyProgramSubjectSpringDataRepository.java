package sk.uniza.fri.alfri.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.StudyProgramSubjectId;

public interface StudyProgramSubjectSpringDataRepository
    extends JpaRepository<StudyProgramSubject, StudyProgramSubjectId>,
    JpaSpecificationExecutor<StudyProgramSubject> {
  Optional<StudyProgramSubject> findByIdSubjectId(Integer id);

  @Query("""
        SELECT s FROM StudyProgramSubject s
        WHERE s.obligation = 'Pov.'
        AND s.id.studyProgramId = :studyProgramId
        AND s.recommendedYear <= :recommendedYear
        """)
  List<StudyProgramSubject> findAllMandatorySubjectsForStudyProgramAndYear(
          @Param("studyProgramId") Long studyProgramId,
          @Param("recommendedYear") Integer recommendedYear);
}
