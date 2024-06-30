package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.AnswerText;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.repository.AnswerRepository;
import sk.uniza.fri.alfri.repository.FocusRepository;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.util.ProcessUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class SubjectService implements ISubjectService {
    public static final String CLUSTERING_PREDICTION_SCRIPT_PATH =
            "./python_scripts/predict.py";
    public static final String CLUSTERING_PREDICTION_MODEL_PATH =
            "./python_scripts/kmeans_model.pkl";

    private final StudyProgramSubjectRepository studyProgramSubjectRepository;
    private final SubjectRepository subjectRepository;
    private final AnswerRepository answerRepository;
    private final FocusRepository focusRepository;

    public SubjectService(

            StudyProgramSubjectRepository studyProgramSubjectRepository,
            SubjectRepository subjectRepository, AnswerRepository answerRepository, FocusRepository focusRepository) {

        this.studyProgramSubjectRepository = studyProgramSubjectRepository;
        this.subjectRepository = subjectRepository;
        this.answerRepository = answerRepository;
        this.focusRepository = focusRepository;
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
    public Page<StudyProgramSubject> findAllByStudyProgramId(
            SearchDefinition searchDefinition, PageDefinition pageDefinition) {
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
                new ProcessBuilder(
                        "python3",
                        CLUSTERING_PREDICTION_SCRIPT_PATH,
                        Arrays.toString(focusesAttributes.toArray()),
                        CLUSTERING_PREDICTION_MODEL_PATH);
        String output = ProcessUtils.getOutputFromProces(processBuilder);
        System.out.println(output);

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

        ids.forEach(
                id -> {
                    StudyProgramSubject subject =
                            studyProgramSubjectRepository
                                    .findByIdSubjectId(id)
                                    .orElseThrow(
                                            () ->
                                                    new EntityNotFoundException(
                                                            String.format("Subject with id %d was not found!", id)));
                    subjectList.add(subject);
                });

        return subjectList;
    }

    @Override
    public List<Subject> makeSubjectsFocusPrediction(User user) {
        List<Integer> questionIds = Arrays.asList(115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126);
        List<Answer> focusUserAnswers = this.answerRepository.findByQuestionIdsAndUser(questionIds, user);

        List<Answer> filteredAnswers = focusUserAnswers.stream()
                .filter(answer -> answer.getTexts().stream()
                        .map(AnswerText::getAnswerText)
                        .map(Integer::parseInt)
                        .anyMatch(value -> value > 5))
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

        Map<String, Integer> values = filteredAnswers.stream()
                .flatMap(answer -> answer.getTexts().stream())
                .collect(Collectors.toMap(
                        answerText -> questionToFocusMap.getOrDefault(answerText.getAnswer().getAnswerQuestion().getQuestionIdentifier(), null),
                        answerText -> Integer.parseInt(answerText.getAnswerText()),
                        (oldValue, newValue) -> newValue // handle duplicate keys by taking the new value
                ));

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

        return focusRepository.findSubjectByHashMapValues(mathFocus, logicFocus, programmingFocus, designFocus,
                economicsFocus, managementFocus, hardwareFocus,
                networkFocus, dataFocus, testingFocus,
                languageFocus, physicalFocus);
    }
}
