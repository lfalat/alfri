package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;

import java.util.*;
import java.util.stream.Collectors;

import jakarta.persistence.Tuple;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PageableAssembler;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.dto.KeywordDTO;
import sk.uniza.fri.alfri.dto.StudentYearCountDTO;
import sk.uniza.fri.alfri.dto.SubjectGradeAverageByYearDTO;
import sk.uniza.fri.alfri.dto.focus.FocusCategorySumDTO;
import sk.uniza.fri.alfri.dto.subject.SubjectWithCountDto;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.AnswerText;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.SubjectGrade;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.AnswerRepository;
import sk.uniza.fri.alfri.repository.FocusRepository;
import sk.uniza.fri.alfri.repository.StudentSubjectRepository;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.repository.SubjectGradeRepository;
import sk.uniza.fri.alfri.repository.SubjectKeywordRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.service.FormService;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.infrastructure.dto.*;
import sk.uniza.fri.alfri.service.PythonPredictionService;

@Service
@Slf4j
public class SubjectService implements ISubjectService {
    private static final Map<String, Integer> MARK_MAPPING =
            Map.of("A", 0, "B", 1, "C", 2, "D", 3, "E", 4, "Fx", 5, "*", 6);

    private static final Map<String, String> CHANCE_MODEL_PATHS =
            Map.of("Matematicka analyza 1", "python_scripts/models/mata1.pkl",
                    "Diskretna pravdepodobnost", "python_scripts/models/dp.pkl",
                    "Algoritmy a udajove struktury 1", "python_scripts/models/aus1.pkl",
                    "Diskretna simulacia", "python_scripts/models/model_DIS.pkl", "Optimalizacia sieti",
                    "python_scripts/models/model_OPTS.pkl", "Algoritmy a udajove struktury 2",
                    "python_scripts/models/model_AUS.pkl");

    private static final Map<String, String> MARK_MODEL_PATHS =
            Map.of("Matematicka analyza 1", "python_scripts/models/mata1.h5",
                    "Diskretna pravdepodobnost", "python_scripts/models/dp.h5",
                    "Algoritmy a udajove struktury 1", "python_scripts/models/aus1.h5",
                    "Diskretna simulacia", "python_scripts/models/best_model_DIS.h5",
                    "Optimalizacia sieti", "python_scripts/models/best_model_OPTS.h5",
                    "Algoritmy a udajove struktury 2", "python_scripts/models/best_model_AUS.h5");

    private final StudyProgramSubjectRepository studyProgramSubjectRepository;
    private final SubjectRepository subjectRepository;
    private final AnswerRepository answerRepository;
    private final FocusRepository focusRepository;
    private final SubjectGradeRepository subjectGradeRepository;
    private final StudentService studentService;
    private final FormService formService;
    private final SubjectKeywordRepository subjectKeywordRepository;
    private final AuthService authService;
    private final StudentSubjectRepository studentSubjectRepository;
    private final PythonPredictionService pythonPredictionService;

    public SubjectService(StudyProgramSubjectRepository studyProgramSubjectRepository,
                          SubjectRepository subjectRepository, AnswerRepository answerRepository,
                          FocusRepository focusRepository, SubjectGradeRepository subjectGradeRepository,
                          StudentService studentService, FormService formService,
                          SubjectKeywordRepository subjectKeywordRepository, AuthService authService, StudentSubjectRepository studentSubjectRepository, PythonPredictionService pythonPredictionService) {
        this.studyProgramSubjectRepository = studyProgramSubjectRepository;
        this.subjectRepository = subjectRepository;
        this.subjectGradeRepository = subjectGradeRepository;
        this.answerRepository = answerRepository;
        this.focusRepository = focusRepository;
        this.studentService = studentService;
        this.formService = formService;
        this.subjectKeywordRepository = subjectKeywordRepository;
        this.authService = authService;
        this.studentSubjectRepository = studentSubjectRepository;
        this.pythonPredictionService = pythonPredictionService;
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
    public List<StudyProgramSubject> getSimilarSubjects(List<Subject> originalSubjects) {

        List<Integer> subjectIds = originalSubjects.stream().map(Subject::getId).toList();
        List<Focus> subjectsFocuses = focusRepository.findBySubjectIds(subjectIds);
        List<List<Integer>> focusesAttributes = getFocusesAttributes(subjectsFocuses);
        User currentUser = this.authService.getCurrentUser().orElseThrow(() -> new RuntimeException("Cannot find user."));
        Integer studyProgramId = currentUser.getStudent().getStudyProgramId();

        // Prepare request for remote service
        ClusteringRequestDto req = new ClusteringRequestDto();
        req.setSubjectIds(subjectIds);
        req.setStudyProgramId(studyProgramId);

        ClusteringResponseDto resp = pythonPredictionService.clustering(req);

        if (resp == null) {
            // graceful degradation: no clustering available
            return List.of();
        }

        List<Integer> resultIds = new ArrayList<>();

        if (resp.getRecommendations() != null && !resp.getRecommendations().isEmpty()) {
            for (ClusteringResponseDto.RecommendationDto r : resp.getRecommendations()) {
                if (r != null && r.getId() != null) resultIds.add(r.getId());
            }
        }

        // Ensure we return StudyProgramSubject entities; if resultIds are indexes from legacy flow they may need adjustment in findSubjectByIds
        return resultIds.isEmpty() ? List.of() : findSubjectByIds(resultIds);
    }

    @Override
    public List<StudyProgramSubject> findSubjectByIds(List<Integer> ids) {
        List<StudyProgramSubject> subjectList = new ArrayList<>();

        User currentUser = this.authService.getCurrentUser().orElseThrow(() -> new RuntimeException("Cannot find user."));

        ids.forEach(id -> {
            StudyProgramSubject subject = studyProgramSubjectRepository.findByIdSubjectId(id, currentUser.getStudent().getStudyProgramId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            String.format("Subject with id %d was not found!", id)));
            subjectList.add(subject);
        });

        return subjectList;
    }

    @Override
    public Page<Subject> makeSubjectsFocusPrediction(User user, PageDefinition pageDefinition) {
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

        Pageable pageable = PageableAssembler.from(pageDefinition);

        return focusRepository.findSubjectByHashMapValuesWithPaging(
                mathFocus, logicFocus, programmingFocus, designFocus, economicsFocus, managementFocus,
                hardwareFocus, networkFocus, dataFocus, testingFocus, languageFocus, physicalFocus,
                user.getStudent().getStudyProgramId(), user.getStudent().getYear(), pageable);
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
        // call remote python service
        PassingChanceRequestDto req = new PassingChanceRequestDto();
        // convert integers to doubles
        Map<String, List<Double>> doubleData = new HashMap<>();
        for (Map.Entry<String, List<Integer>> e : subjectInputs.entrySet()) {
            List<Double> doubles = e.getValue().stream().map(i -> i == null ? 6.0 : i.doubleValue()).toList();
            doubleData.put(e.getKey(), doubles);
        }
        req.setSubjects(doubleData);

        PassingChanceResponseDto resp = pythonPredictionService.passingChance(req);
        Map<String, ProbabilityResultDto> results = resp.getResults();
        return results.entrySet().stream().map(entry -> entry.getKey() + ": " + entry.getValue().getProbability() * 100).toList();

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

        // call remote python service per subject and aggregate results
        List<String> results = new ArrayList<>();
        for (String subjectName : subjectNames) {
            PassingMarkRequestDto req = new PassingMarkRequestDto();
            req.setSubject(subjectName);
            List<Double> doubles = subjectInputs.get(subjectName).stream().map(i -> i == null ? 6.0 : i.doubleValue()).toList();
            req.setFeatures(doubles);
            PassingMarkResponseDto resp = pythonPredictionService.passingMark(req);
            results.add(subjectName + ": " + resp.getChosenGrade());
        }
        return results;
    }

    @Override
    public List<FocusCategorySumDTO> getMostPopularFocuses() {
        List<Tuple> tuples = this.focusRepository.findFocusCategorySums();
        return tuples.stream()
                .map(tuple -> new FocusCategorySumDTO(
                        tuple.get("focus_category", String.class),
                        tuple.get("total_sum", Long.class)
                ))
                .toList();
    }

    @Override
    public List<KeywordDTO> getAllKeywords() {
        List<Tuple> tuples = this.subjectKeywordRepository.getAllSummed();
        return tuples.stream()
                .map(tuple -> new KeywordDTO(
                        tuple.get("keyword", String.class),
                        tuple.get("count", Long.class)
                ))
                .toList();
    }

    @Override
    public List<StudentYearCountDTO> getStudentCountsByYear() {
        return this.studentSubjectRepository.countStudentsByYear().stream()
                .map(tuple -> new StudentYearCountDTO(
                        tuple.get("year", Integer.class),
                        tuple.get("studentCount", Long.class)
                ))
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
            case "Modelovanie a simulácia" -> {
                return List.of(getMarkOfSubjectFromQuestionnaire("Pravdepodobnosť a štatistika", user),
                        getMarkOfSubjectFromQuestionnaire("Diskrétna optimalizácia", user),
                        getMarkOfSubjectFromQuestionnaire("Matematická analýza 1", user));
            }
            case "Princípy operačných systémov" -> {
                return List.of(getMarkOfSubjectFromQuestionnaire("Algoritmy a údajové štruktúry 1", user),
                        getMarkOfSubjectFromQuestionnaire("Informatika 3", user),
                        getMarkOfSubjectFromQuestionnaire("Číslicové počítače", user));
            }
            case "Vývoj aplikácií pre internet a intranet" -> {
                return List.of(getMarkOfSubjectFromQuestionnaire("Databázové systémy", user),
                        getMarkOfSubjectFromQuestionnaire("Diskrétna optimalizácia", user),
                        getMarkOfSubjectFromQuestionnaire("Informatika 3", user));
            }
            case "Algoritmy a udajove struktury 2" -> {
                return List.of(getMarkOfSubjectFromQuestionnaire("Algoritmy a údajové štruktúry 1", user),
                        getMarkOfSubjectFromQuestionnaire("Algoritmy a údajové štruktúry 1", user),
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
            case 3 -> {
                return List.of("Modelovanie a simulácia", "Princípy operačných systémov", "Vývoj aplikácií pre internet a intranet");
            }
            case 4 -> {
                return List.of("Algoritmy a udajove struktury 2", "Optimalizacia sieti",
                        "Diskretna simulacia");
            }
            default -> throw new IllegalArgumentException(
                    String.format("Student year %d cannot be predicted!", studentYear));
        }
    }

    @Override
    public Page<SubjectGrade> getSubjectsWithGrades(PageDefinition pageDefinition, String search) {
        Pageable pageable = PageableAssembler.from(pageDefinition);
        if (search != null && !search.isBlank()) {
            return subjectGradeRepository.findBySubjectNameOrCode(search, pageable);
        }
        return subjectGradeRepository.findAll(pageable);
    }

    @Override
    public Page<SubjectWithCountDto> getMostPopularElectiveSubjects(PageDefinition pageDefinition) {
        return this.studyProgramSubjectRepository.findMostPopularElectiveSubjects(pageDefinition);
    }

    @Override
    public List<SubjectGradeAverageByYearDTO> getSubjectGradeAveragesByYear(Integer subjectId) {
        log.info("Getting grade averages for subject with id {} grouped by year", subjectId);
        List<Tuple> results = studentSubjectRepository.findGradeAverageBySubjectIdGroupedByYear(subjectId);

        return results.stream()
                .map(tuple -> new SubjectGradeAverageByYearDTO(
                        tuple.get("year", Integer.class),
                        tuple.get("averageGrade", Double.class),
                        tuple.get("studentCount", Long.class)
                ))
                .toList();
    }
}