package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ResourceLoader;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.util.ProcessUtils;

@Service
@Slf4j
public class SubjectService implements ISubjectService {
    public static final String CLUSTERING_PREDICTION_SCRIPT_PATH =
            "./python_scripts/predict.py";
    public static final String CLUSTERING_PREDICTION_MODEL_PATH =
            "./python_scripts/kmeans_model.pkl";

    private final StudyProgramSubjectRepository studyProgramSubjectRepository;
    private final SubjectRepository subjectRepository;

    public SubjectService(

            StudyProgramSubjectRepository studyProgramSubjectRepository,
            SubjectRepository subjectRepository) {

        this.studyProgramSubjectRepository = studyProgramSubjectRepository;
        this.subjectRepository = subjectRepository;
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
        String output = ProcessUtils.getOutputFromProces(processBuilder);System.out.println(output);

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
}
