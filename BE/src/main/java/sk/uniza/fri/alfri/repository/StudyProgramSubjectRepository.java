package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.StudyProgramSubjectId;

public interface StudyProgramSubjectRepository
    extends JpaRepository<StudyProgramSubject, StudyProgramSubjectId> {
  Page<StudyProgramSubject> findAllById_StudyProgram_Id(int studyProgramId, Pageable page);
}
