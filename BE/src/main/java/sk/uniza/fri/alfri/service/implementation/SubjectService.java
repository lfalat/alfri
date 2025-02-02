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
import sk.uniza.fri.alfri.constant.ModelType;
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
import sk.uniza.fri.alfri.service.FormService;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.util.ProcessUtils;

@Service
@Slf4j
public class SubjectService implements ISubjectService {
  public static final String NO_SUBJECTS_FOUND_MESSAGE = "No subjects found!";

  private static final Map<String, Integer> MARK_MAPPING =
      Map.of("A", 0, "B", 1, "C", 2, "D", 3, "E", 4, "Fx", 5, "*", 6);

  private static final Map<String, String> CHANCE_MODEL_PATHS =
      Map.of("Matematicka analyza 1", "/app/python_scripts/models/mata1.pkl",
          "Diskretna pravdepodobnost", "/app/python_scripts/models/dp.pkl",
          "Algoritmy a udajove struktury 1", "/app/python_scripts/models/aus1.pkl",
          "Diskretna simulacia", "/app/python_scripts/models/model_DIS.pkl", "Optimalizacia sieti",
          "/app/python_scripts/models/model_OPTS.pkl", "Algoritmy a udajove struktury 2",
          "/app/python_scripts/models/model_AUS.pkl");

  private static final Map<String, String> MARK_MODEL_PATHS =
      Map.of("Matematicka analyza 1", "/app/python_scripts/models/mata1.h5",
          "Diskretna pravdepodobnost", "/app/python_scripts/models/dp.h5",
          "Algoritmy a udajove struktury 1", "/app/python_scripts/models/aus1.h5",
          "Diskretna simulacia", "/app/python_scripts/models/best_model_DIS.h5",
          "Optimalizacia sieti", "/app/python_scripts/models/best_model_OPTS.h5",
          "Algoritmy a udajove struktury 2", "/app/python_scripts/models/best_model_AUS.h5");

  private final StudyProgramSubjectRepository studyProgramSubjectRepository;
  private final SubjectRepository subjectRepository;
  private final AnswerRepository answerRepository;
  private final FocusRepository focusRepository;
  private final SubjectGradeRepository subjectGradeRepository;
  private final StudentService studentService;
  private final FormService formService;

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
      StudentService studentService, FormService formService) {

    this.studyProgramSubjectRepository = studyProgramSubjectRepository;
    this.subjectRepository = subjectRepository;
    this.subjectGradeRepository = subjectGradeRepository;
    this.answerRepository = answerRepository;
    this.focusRepository = focusRepository;
    this.studentService = studentService;
    this.formService = formService;
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
        .filter(answer -> answer.getTexts().stream().map(AnswerText::getTextOfAnswer)
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
                answerText -> Integer.parseInt(answerText.getTextOfAnswer()),
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
  public List<String> makePassingChancePrediction(String userEmail) {
    Student userStudent = studentService.getStudentByUserEmail(userEmail);
    int studentYear = userStudent.getYear();

    List<String> subjectNames = this.getSubjectNamesToPredictByStudentsYear(studentYear);

    Map<String, List<Integer>> subjectInputs = new HashMap<>();
    subjectNames.forEach(subjectName -> subjectInputs.put(subjectName, this
        .getMarksRequiredToPredictSubjectFromQuestionnaire(subjectName, userStudent.getUser())));

    log.info("Subjects inputs: {}", subjectInputs);

    Map<String, String> modelPaths =
        subjectNames.stream().collect(Collectors.toMap(subjectName -> subjectName,
            subjectName -> getModelPath(subjectName, ModelType.CHANCE)));

    ObjectMapper mapper = new ObjectMapper();
    String inputJson;
    String modelPathsJson;
    try {
      inputJson = mapper.writeValueAsString(Map.of("data", subjectInputs));
      modelPathsJson = mapper.writeValueAsString(modelPaths);
    } catch (JsonProcessingException e) {
      throw new PythonOutputParsingException("Failed to create JSON input for the python script");
    }

    ProcessBuilder processBuilder = new ProcessBuilder(pythonExcecutablePath,
        passingChangePredictionScriptPath, inputJson, modelPathsJson);

    String output;
    try {
      output = ProcessUtils.getOutputFromProces(processBuilder);
    } catch (IOException e) {
      throw new PythonOutputParsingException(
          "Error running Python passing chance script: " + e.getMessage());
    }

    log.info("Output of makePassingChancePrediction: {}", output);

    Map<String, String> predictions;
    try {
      predictions = mapper.readValue(output, new TypeReference<>() {});
    } catch (IOException e) {
      throw new PythonOutputParsingException(
          String.format("There was an error parsing passing chance. Output: %s", output.trim()));
    }

    log.info("Returning predictions: {}", predictions);

    return predictions.entrySet().stream().map(entry -> entry.getKey() + ": " + entry.getValue())
        .toList();
  }

  @Override
  public List<String> makePassingMarkPrediction(String userEmail) {
    Student userStudent = studentService.getStudentByUserEmail(userEmail);
    int studentYear = userStudent.getYear();

    List<String> subjectNames = this.getSubjectNamesToPredictByStudentsYear(studentYear);

    Map<String, List<Integer>> subjectInputs = new HashMap<>();

    subjectNames.forEach(subjectName -> subjectInputs.put(subjectName, this
        .getMarksRequiredToPredictSubjectFromQuestionnaire(subjectName, userStudent.getUser())));

    log.info("Subjects inputs: {}", subjectInputs);

    Map<String, String> modelPaths =
        subjectNames.stream().collect(Collectors.toMap(subjectName -> subjectName,
            subjectName -> getModelPath(subjectName, ModelType.MARK)));

    ObjectMapper mapper = new ObjectMapper();
    String inputJson;
    String modelPathsJson;

    try {
      inputJson = mapper.writeValueAsString(Map.of("data", subjectInputs));
      modelPathsJson = mapper.writeValueAsString(modelPaths);
    } catch (JsonProcessingException e) {
      throw new PythonOutputParsingException("Failed to create JSON input for the python script");
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

    log.info("Returning predictions: {}", predictions);

    return predictions.entrySet().stream().map(entry -> entry.getKey() + ": " + entry.getValue())
        .toList();
  }

    private List<Integer> getMarksRequiredToPredictSubjectFromQuestionnaire(String subjectName,
      User user) {
    log.info("Getting related subjects for subject {}", subjectName);
    switch (subjectName) {
      case "Matematicka analyza 1" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Algebra", user),
            getMarkOfSubjectFromQuestionnaire("Matematika pre informatikov", user),
            getMarkOfSubjectFromQuestionnaire("Diskrétna pravdepodobnosť", user));
      }
      case "Algoritmy a udajove struktury 1" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Informatika 1", user),
            getMarkOfSubjectFromQuestionnaire("Informatika 2", user),
            getMarkOfSubjectFromQuestionnaire("Algoritmická teória grafov", user));
      }
      case "Diskretna pravdepodobnost" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Algebra", user),
            getMarkOfSubjectFromQuestionnaire("Matematika pre informatikov", user));
      }

      case "Algoritmy a udajove struktury 2" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Algoritmy a údajové štruktúry 1", user),
            getMarkOfSubjectFromQuestionnaire("Informatika 3", user),
            getMarkOfSubjectFromQuestionnaire("Informatika 2", user));
      }

      case "Optimalizacia sieti" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Matematika pre informatikov", user),
            getMarkOfSubjectFromQuestionnaire("Algoritmická teória grafov", user),
            getMarkOfSubjectFromQuestionnaire("Diskrétna optimalizácia", user));
      }

      case "Diskretna simulacia" -> {
        return List.of(getMarkOfSubjectFromQuestionnaire("Diskrétna pravdepodobnosť", user),
            getMarkOfSubjectFromQuestionnaire("Pravdepodobnosť a štatistika", user),
            getMarkOfSubjectFromQuestionnaire("Diskrétna optimalizácia", user));
      }
      default -> throw new IllegalArgumentException(
          "Unknown subject name to predict: " + subjectName);
    }
  }

  private Integer getMarkOfSubjectFromQuestionnaire(String subjectName, User user) {
    String markOfSubjectFromQuesionnaire =
        formService.getMarkOfSubjectFromQuesionnaire(subjectName, user);

    if (markOfSubjectFromQuesionnaire == null) {
      return 6; // Fallback value
    }

    return MARK_MAPPING.getOrDefault(markOfSubjectFromQuesionnaire, 6);
  }

  private List<String> getSubjectNamesToPredictByStudentsYear(int studentYear) {
    switch (studentYear) {
      case 2 -> {
        return List.of("Matematicka analyza 1", "Algoritmy a udajove struktury 1",
            "Diskretna pravdepodobnost");
      }
      case 4 -> {
        return List.of("Algoritmy a udajove struktury 2", "Optimalizacia sieti",
            "Diskretna simulacia");
      }
      default -> throw new IllegalArgumentException(
          String.format("Student year %d cannot be predicted!", studentYear));
    }
  }

  private String getModelPath(String subjectName, ModelType type) {
    return switch (type) {
      case CHANCE -> CHANCE_MODEL_PATHS.get(subjectName);
      case MARK -> MARK_MODEL_PATHS.get(subjectName);
    };
  }

  @Override
  public List<SubjectGrade> getFilteredSubjects(String sortCriteria, Integer numberOfSubjects) {
    Pageable pageable = PageRequest.of(0, numberOfSubjects);

    Page<SubjectGrade> subjectPage = switch (sortCriteria) {
      case "lowestAverage" -> subjectGradeRepository.findAllByOrderByGradeAverageAsc(pageable)
          .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
      case "highestAverage" -> subjectGradeRepository.findAllByOrderByGradeAverageDesc(pageable)
          .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
      case "mostAGrades" -> subjectGradeRepository.findAllByOrderByGradeADesc(pageable)
          .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
      case "mostFXGrades" -> subjectGradeRepository.findAllByOrderByGradeFxDesc(pageable)
          .orElseThrow(() -> new EntityNotFoundException(NO_SUBJECTS_FOUND_MESSAGE));
      default -> throw new IllegalArgumentException("Invalid sorting criteria");
    };

    return subjectPage.getContent();
  }
}
