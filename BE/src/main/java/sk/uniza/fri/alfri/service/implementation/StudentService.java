package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.StudentRepository;
import sk.uniza.fri.alfri.repository.StudyProgramRepository;
import sk.uniza.fri.alfri.service.IStudentService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class StudentService implements IStudentService {
  private final StudentRepository studentRepository;
  private final StudyProgramRepository studyProgramRepository;
  private final ResourceLoader resourceLoader;

  public StudentService(
      StudentRepository studentRepository, StudyProgramRepository studyProgramRepository, ResourceLoader resourceLoader) {
    this.studentRepository = studentRepository;
    this.studyProgramRepository = studyProgramRepository;
    this.resourceLoader = resourceLoader;
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

  @Override
  public void makePrediction() throws IOException, InterruptedException {
    // TODO: refactor
    Resource resourceModel = resourceLoader.getResource("classpath:python_scripts/kmeans_model.pkl");
    String modelPath = resourceModel.getFile().getAbsolutePath();

    Resource resource = resourceLoader.getResource("classpath:python_scripts/predict.py");
    String pythonScriptPath = resource.getFile().getAbsolutePath();

    Resource requirementsResource = resourceLoader.getResource("classpath:python_scripts/requirements.txt");
    String requirementsPath = requirementsResource.getFile().getAbsolutePath();

    List<Integer> list = Arrays.asList(1, 2, 3, 4 ,5, 6, 7, 8, 9, 10, 10, 10);

    // Install the required Python modules
    ProcessBuilder installProcessBuilder = new ProcessBuilder("python", "-m", "pip", "install", "-r", requirementsPath);
    installProcessBuilder.redirectErrorStream(true);
    Process installProcess = installProcessBuilder.start();
    BufferedReader installReader = new BufferedReader(new InputStreamReader(installProcess.getInputStream()));
    StringBuilder installOutput = new StringBuilder();
    String installLine;
    while ((installLine = installReader.readLine()) != null) {
      installOutput.append(installLine).append("\n");
    }
    int installExitCode = installProcess.waitFor();
    if (installExitCode != 0) {
      throw new RuntimeException("pip install failed: " + installOutput);
    }
    System.out.println(installOutput);

    ProcessBuilder processBuilder = new ProcessBuilder("python", pythonScriptPath, list.toString(), modelPath);
    processBuilder.redirectErrorStream(true);

    Process process = processBuilder.start();
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    StringBuilder output = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
      output.append(line);
    }
    String cleaned = output.toString().replace("[", "").replace("]", "");
    String[] parts = cleaned.split(" ");
    List<Integer> result = new ArrayList<>();
    for (String part : parts) {
      result.add(Integer.parseInt(part) + 89);
    }
    System.out.println(result);

  }
}
