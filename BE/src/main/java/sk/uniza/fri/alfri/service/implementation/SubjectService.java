package sk.uniza.fri.alfri.service.implementation;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.AnswerText;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.SubjectGrade;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.PythonOutputParsingException;
import sk.uniza.fri.alfri.repository.AnswerRepository;
import sk.uniza.fri.alfri.repository.FocusRepository;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.repository.SubjectGradeRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.util.ProcessUtils;

@Service
@Slf4j
public class SubjectService implements ISubjectService {
  public static final String NO_SUBJECTS_FOUND_MESSAGE = "No subjects found!";

  private final StudyProgramSubjectRepository studyProgramSubjectRepository;
  private final SubjectRepository subjectRepository;
  private final AnswerRepository answerRepository;
  private final FocusRepository focusRepository;
  private final SubjectGradeRepository subjectGradeRepository;
  private final StudentService studentService;

  @Value("${python.executable_path}")
  private String pythonExcecutablePath;

  @Value("${python.clustering_prediction_script_path}")
  private String clusteringPredictionScriptPath;

  @Value("${python.clustering_prediction_model_path}")
  private String clusteringPredictionModelPath;

  @Value("${python.passing_change_prediction_script_path}")
  private String passingChangePredictionScriptPath;

  @Value("${python.passing_mark_prediction_script_path}")
  private String passingMarkPredictionScriptPath;

  public SubjectService(StudyProgramSubjectRepository studyProgramSubjectRepository,
      SubjectRepository subjectRepository, AnswerRepository answerRepository,
      FocusRepository focusRepository, SubjectGradeRepository subjectGradeRepository,
      StudentService studentService) {

    this.studyProgramSubjectRepository = studyProgramSubjectRepository;
    this.subjectRepository = subjectRepository;
    this.subjectGradeRepository = subjectGradeRepository;
    this.answerRepository = answerRepository;
    this.focusRepository = focusRepository;
    this.studentService = studentService;
  }

  private static List<List<Integer>> getFocusesAttributes(List<Focus> subjectsFocuses) {
    List<List<Integer>> focusesAttributes = new ArrayList<>();

    for (Focus focus : subjectsFocuses) {
      List<Integer> focusAttributes = new ArrayList<>();
      focusAttributes.add(focus.getMathFocus());
      focusAttributes.add(focus.getLogicFocus());
      focusAttributes.add(focus.getProgrammingFocus());
      focusAttributes.add(focus.getDesignFocus());
      focusAttributes.add(focus.getEconomicsFocus());
      focusAttributes.add(focus.getManagementFocus());
      focusAttributes.add(focus.getHardwareFocus());
      focusAttributes.add(focus.getNetworkFocus());
      focusAttributes.add(focus.getDataFocus());
      focusAttributes.add(focus.getTestingFocus());
      focusAttributes.add(focus.getLanguageFocus());
      focusAttributes.add(focus.getPhysicalFocus());
      focusesAttributes.add(focusAttributes);
    }
    return focusesAttributes;
  }

  @Override
  public Page<StudyProgramSubject> findAllByStudyProgramId(SearchDefinition searchDefinition,
      PageDefinition pageDefinition) {
    return this.studyProgramSubjectRepository.findAllByFilter(searchDefinition, pageDefinition);
  }

  @Override
  public Subject findBySubjectCode(String subjectCode) {
    return this.subjectRepository.findSubjectByCode(subjectCode);
  }

  @Override
  public List<StudyProgramSubject> getSimilarSubjects(List<Subject> originalSubjects)
      throws IOException {

    List<Focus> subjectsFocuses = originalSubjects.stream().map(Subject::getFocus).toList();
    List<List<Integer>> focusesAttributes = getFocusesAttributes(subjectsFocuses);

    ProcessBuilder processBuilder =
        new ProcessBuilder(pythonExcecutablePath, clusteringPredictionScriptPath,
            Arrays.toString(focusesAttributes.toArray()), clusteringPredictionModelPath);
    String output = ProcessUtils.getOutputFromProces(processBuilder);
    log.info("Output of clustering: {}", output);

    String cleaned = output.replace("[", "").replace("]", "").replace("\"", "");
    String[] parts = cleaned.split(" ");
    List<Integer> result = new ArrayList<>();
    for (String part : parts) {
      if (part.isEmpty()) {
        continue;
      }
      part = part.strip();
      result.add(Integer.parseInt(part) + 89);
    }

    return findSubjectByIds(result);
  }

  @Override
  public List<StudyProgramSubject> findSubjectByIds(List<Integer> ids) {
    List<StudyProgramSubject> subjectList = new ArrayList<>();

    ids.forEach(id -> {
      StudyProgramSubject subject = studyProgramSubjectRepository.findByIdSubjectId(id)
          .orElseThrow(() -> new EntityNotFoundException(
              String.format("Subject with id %d was not found!", id)));
      subjectList.add(subject);
    });

    return subjectList;
  }

  @Override
  public List<Subject> makeSubjectsFocusPrediction(User user) {
    List<Integer> questionIds =
        Arrays.asList(115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126);
    List<Answer> focusUserAnswers =
        this.answerRepository.findByQuestionIdsAndUser(questionIds, user);

    List<Answer> filteredAnswers = focusUserAnswers.stream()
        .filter(answer -> answer.getTexts().stream().map(AnswerText::getAnswerText)
            .map(Integer::parseInt).anyMatch(value -> value > 5))
        .toList();

    Map<String, String> questionToFocusMap = new HashMap<>();
    questionToFocusMap.put("question_matematika_focus", "math_focus");
    questionToFocusMap.put("question_dizajn_focus", "design_focus");
    questionToFocusMap.put("question_hardver_focus", "hardware_focus");
    questionToFocusMap.put("question_testovanie_focus", "testing_focus");
    questionToFocusMap.put("question_logika_focus", "logic_focus");
    questionToFocusMap.put("question_ekonomika_focus", "economics_focus");
    questionToFocusMap.put("question_siete_focus", "network_focus");
    questionToFocusMap.put("question_jazyky_focus", "language_focus");
    questionToFocusMap.put("question_programovanie_focus", "programming_focus");
    questionToFocusMap.put("question_manazment_focus", "management_focus");
    questionToFocusMap.put("question_data_focus", "data_focus");
    questionToFocusMap.put("question_fyzicka_aktivita_focus", "physical_focus");

    Map<String, Integer> values =
        filteredAnswers.stream().flatMap(answer -> answer.getTexts().stream())
            .collect(Collectors.toMap(
                answerText -> questionToFocusMap.getOrDefault(
                    answerText.getAnswer().getAnswerQuestion().getQuestionIdentifier(), null),
                answerText -> Integer.parseInt(answerText.getAnswerText()),
                (oldValue, newValue) -> newValue));

    Integer mathFocus = values.getOrDefault("math_focus", null);
    Integer logicFocus = values.getOrDefault("logic_focus", null);
    Integer programmingFocus = values.getOrDefault("programming_focus", null);
    Integer designFocus = values.getOrDefault("design_focus", null);
    Integer economicsFocus = values.getOrDefault("economics_focus", null);
    Integer managementFocus = values.getOrDefault("management_focus", null);
    Integer hardwareFocus = values.getOrDefault("hardware_focus", null);
    Integer networkFocus = values.getOrDefault("network_focus", null);
    Integer dataFocus = values.getOrDefault("data_focus", null);
    Integer testingFocus = values.getOrDefault("testing_focus", null);
    Integer languageFocus = values.getOrDefault("language_focus", null);
    Integer physicalFocus = values.getOrDefault("physical_focus", null);

    return focusRepository.findSubjectByHashMapValues(mathFocus, logicFocus, programmingFocus,
        designFocus, economicsFocus, managementFocus, hardwareFocus, networkFocus, dataFocus,
        testingFocus, languageFocus, physicalFocus);
  }

  @Override
  public List<Subject> findAll() {
    return subjectRepository.findAll();
  }

  @Override
  public List<Double> makePassingChancePrediction(String userEmail) {
    String output;
    try {
      output = runPythonModelForPrediction(userEmail, passingMarkPredictionScriptPath);
    } catch (IOException e) {
      throw new PythonOutputParsingException(e.getMessage());
    }

    log.info("Output of makePassingChancePrediction: {}", output);

    try {
      return Arrays.stream(output.trim().split("\\s+")).map(Double::parseDouble).toList();
    } catch (NumberFormatException e) {
      throw new PythonOutputParsingException(
          String.format("There was error parsing passing chance with output:%s ", output.trim()));
    }
  }

  @Override
  public List<String> makePassingMarkPrediction(String userEmail) {
    Student userStudent = studentService.getStudentByUserEmail(userEmail);
    int studentYear = userStudent.getYear();

    // Create a map of subject to their encoded input arrays.
    // Each subject has its own array of features.
    Map<String, List<Integer>> subjectInputs = new HashMap<>();
    subjectInputs.put("Matematicka analyza 1", Arrays.asList(0, 0, 0));
    subjectInputs.put("Algoritmy a udajove struktury 1", Arrays.asList(0, 0, 0));
    subjectInputs.put("Diskretna pravdepodobnost", Arrays.asList(0, 0));
    // Add more subjects and their corresponding arrays here.

    // Model paths map
    Map<String, String> modelPaths =
        Map.of("Matematicka analyza 1", "/app/python_scripts/models/mata1.h5",
            "Diskretna pravdepodobnost", "/app/python_scripts/models/dp.h5",
            "Algoritmy a udajove struktury 1", "/app/python_scripts/models/aus1.h5");

    ObjectMapper mapper = new ObjectMapper();
    String inputJson;
    String modelPathsJson;

    try {
      // Now 'data' is a dictionary of subjects to arrays
      inputJson = mapper.writeValueAsString(Map.of("data", subjectInputs));
      modelPathsJson = mapper.writeValueAsString(modelPaths);
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Failed to create JSON input for the python script", e);
    }

    ProcessBuilder processBuilder = new ProcessBuilder(pythonExcecutablePath,
        passingMarkPredictionScriptPath, inputJson, modelPathsJson);

    String output;
    try {
      output = ProcessUtils.getOutputFromProces(processBuilder);
    } catch (IOException e) {
      throw new PythonOutputParsingException(
          "Error running Python prediction script: " + e.getMessage());
    }

    log.info("Output of makePassingMarkPrediction: {}", output);

    Map<String, String> predictions;
    try {
      predictions = mapper.readValue(output, new TypeReference<>() {});
    } catch (IOException e) {
      throw new PythonOutputParsingException(
          String.format("There was error parsing passing mark with output: %s ", output.trim()));
    }

    return new ArrayList<>(predictions.values());
  }

  private String runPythonModelForPrediction(String userEmail,
      String passingMarkPredictionScriptPath) throws IOException {
    Student userStudent = studentService.getStudentByUserEmail(userEmail);
    int studentYear = userStudent.getYear();

    ProcessBuilder processBuilder = new ProcessBuilder(pythonExcecutablePath,
        passingMarkPredictionScriptPath, String.valueOf(studentYear));

    return ProcessUtils.getOutputFromProces(processBuilder);
  }

  @Override
  public List<SubjectGrade> getFilteredSubjects(String sortCriteria, Integer numberOfSubjects) {
    Pageable pageable = PageRequest.of(0, numberOfSubjects);

    Page<SubjectGrade> subjectPage;

    switch (sortCriteria) {
      case "lowestAverage":
        subjectPage = subjectGradeRepository.findAllByOrderByGradeAverageAsc(pageable)
            .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
        break;

      case "highestAverage":
        subjectPage = subjectGradeRepository.findAllByOrderByGradeAverageDesc(pageable)
            .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
        break;

      case "mostAGrades":
        subjectPage = subjectGradeRepository.findAllByOrderByGradeADesc(pageable)
            .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
        break;

      case "mostFXGrades":
        subjectPage = subjectGradeRepository.findAllByOrderByGradeFxDesc(pageable)
            .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
        break;

      default:
        throw new IllegalArgumentException("Invalid sorting criteria");
    }

    return subjectPage.getContent();
  }
}
