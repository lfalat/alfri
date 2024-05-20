package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.StudentRepository;
import sk.uniza.fri.alfri.repository.StudyProgramRepository;
import sk.uniza.fri.alfri.service.IStudentService;

@Service
public class StudentService implements IStudentService {
  private final StudentRepository studentRepository;
  private final StudyProgramRepository studyProgramRepository;

  public StudentService(
      StudentRepository studentRepository, StudyProgramRepository studyProgramRepository) {
    this.studentRepository = studentRepository;
    this.studyProgramRepository = studyProgramRepository;
  }

  public StudyProgram getUsersStudyProgram(String userEmail) {
    Student student =
        studentRepository
            .findByUser_Email(userEmail)
            .orElseThrow(
                () ->
                    new EntityNotFoundException(
                        String.format("User with email %s is not student", userEmail)));

    return studyProgramRepository
        .findById(student.getStudyProgramId())
        .orElseThrow(
            () ->
                new EntityNotFoundException(
                    String.format("No study program was found for student %s", student)));
  }

  @Override
  public StudyProgram getUsersStudyProgram(User user) {
    return getUsersStudyProgram(user.getEmail());
  }
}
