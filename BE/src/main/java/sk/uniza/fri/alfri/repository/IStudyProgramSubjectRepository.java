package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.StudyProgramSubjectId;

public interface IStudyProgramSubjectRepository
    extends JpaRepository<StudyProgramSubject, StudyProgramSubjectId> {}
