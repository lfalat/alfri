package sk.uniza.fri.alfri.service.implementation;

import java.util.List;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.repository.StudyProgramRepository;
import sk.uniza.fri.alfri.service.IStudyProgramService;

@Service
public class StudyProgramService implements IStudyProgramService {
  private final StudyProgramRepository studyProgramRepository;

  public StudyProgramService(StudyProgramRepository studyProgramRepository) {
    this.studyProgramRepository = studyProgramRepository;
  }

  @Override
  public List<StudyProgram> findAll() {
    return studyProgramRepository.findAll();
  }
}
