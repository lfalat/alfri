package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.StudyProgram;

public interface IStudyProgramRepository extends JpaRepository<StudyProgram, Integer> {}
