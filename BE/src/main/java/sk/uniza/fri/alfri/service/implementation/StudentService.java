package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;

import java.io.IOException;

import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.StudentRepository;
import sk.uniza.fri.alfri.repository.StudyProgramRepository;
import sk.uniza.fri.alfri.service.IStudentService;
import sk.uniza.fri.alfri.util.ProcessUtils;

@Service
public class StudentService implements IStudentService {
  private final StudentRepository studentRepository;
  private final StudyProgramRepository studyProgramRepository;
  private final ResourceLoader resourceLoader;

  public StudentService(StudentRepository studentRepository,
      StudyProgramRepository studyProgramRepository, ResourceLoader resourceLoader) {
    this.studentRepository = studentRepository;
    this.studyProgramRepository = studyProgramRepository;
    this.resourceLoader = resourceLoader;
  }

  public StudyProgram getUsersStudyProgram(String userEmail) {
    Student student =
        studentRepository.findByUser_Email(userEmail).orElseThrow(() -> new EntityNotFoundException(
            String.format("User with email %s is not student", userEmail)));

    return studyProgramRepository.findById(student.getStudyProgramId())
        .orElseThrow(() -> new EntityNotFoundException(
            String.format("No study program was found for student %s", student)));
  }

  @Override
  public StudyProgram getUsersStudyProgram(User user) {
    return getUsersStudyProgram(user.getEmail());
  }

  @Override
  public void makePrediction() throws IOException {
    ProcessBuilder processBuilder =
        new ProcessBuilder("python3", "./python_scripts/passing_chance_prediction.py");
    String output = ProcessUtils.getOutputFromProces(processBuilder, false);
    System.out.println(output);
  }

  @Override
  public Student getStudentByUserEmail(String userEmail) {
    return studentRepository.findByUser_Email(userEmail)
        .orElseThrow(() -> new EntityNotFoundException(
            String.format("User with email %s is not a student!", userEmail)));
  }
}
