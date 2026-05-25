package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.Session;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerDTO;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerTextDTO;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerType;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionDTO;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.AnswerText;
import sk.uniza.fri.alfri.entity.Question;
import sk.uniza.fri.alfri.entity.QuestionOption;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.QuestionnaireSection;
import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.exception.QuestionnaireNotFilledException;
import sk.uniza.fri.alfri.mapper.AnswerMapper;
import sk.uniza.fri.alfri.mapper.QuestionnaireMapper;
import sk.uniza.fri.alfri.repository.AnswerRepository;
import sk.uniza.fri.alfri.repository.AnswerTextRepository;
import sk.uniza.fri.alfri.repository.QuestionRepository;
import sk.uniza.fri.alfri.repository.QuestionnaireRepository;
import sk.uniza.fri.alfri.repository.StudentRepository;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.service.FormService;

import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@Slf4j
@Transactional
public class FormServiceImpl implements FormService {
    private final QuestionnaireRepository questionnaireRepository;
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    private final AnswerTextRepository answerTextRepository;
    private final StudyProgramSubjectRepository studyProgramSubjectRepository;
  private final EntityManager entityManager;
  private final StudentRepository studentRepository;

    public FormServiceImpl(QuestionnaireRepository questionnaireRepository,
                           QuestionRepository questionRepository, AnswerRepository answerRepository,
                           AnswerTextRepository answerTextRepository,
                           StudyProgramSubjectRepository studyProgramSubjectRepository, EntityManager entityManager,
                           StudentRepository studentRepository) {
        this.questionnaireRepository = questionnaireRepository;
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
        this.answerTextRepository = answerTextRepository;
        this.studyProgramSubjectRepository = studyProgramSubjectRepository;
        this.entityManager = entityManager;
        this.studentRepository = studentRepository;
    }

    public void saveQuestionnaire(QuestionnaireDTO questionnaireDTO) {
        Questionnaire questionnaire = QuestionnaireMapper.INSTANCE.toEntity(questionnaireDTO);

        for (QuestionnaireSection section : questionnaire.getSections()) {
            Set<String> questionIdentifiers = new HashSet<>();
            section.setQuestionnaire(questionnaire);

            // Create a set to store the positions and check for duplicates or missing positions
            Set<Integer> positions = new HashSet<>();
            int numberOfQuestions = section.getQuestions().size();

            for (Question question : section.getQuestions()) {
                int position = question.getPositionInQuestionnaire();

                // Check for unique questionIdentifier
                if (!questionIdentifiers.add(question.getQuestionIdentifier())) {
                    throw new IllegalArgumentException(
                            "Duplicate questionIdentifier: " + question.getQuestionIdentifier());
                }

                // Check if position is within the valid range and not a duplicate
                if (position < 1 || position > numberOfQuestions || !positions.add(position)) {
                    throw new IllegalArgumentException("Invalid positionInQuestionnaire in form");
                }

                question.setQuestionnaireSection(section);

                // Validate options for non-optional questions
                if (Boolean.TRUE.equals(!question.getOptional())
                        && (question.getOptions() == null || question.getOptions().isEmpty())
                        && (question.getAnswerType() == AnswerType.RADIO.getId()
                        || question.getAnswerType() == AnswerType.CHECKBOX.getId()
                        || question.getAnswerType() == AnswerType.DROPDOWN.getId())) {
                    throw new IllegalArgumentException(
                            "Question with identifier '" + question.getQuestionIdentifier()
                                    + "' is not optional but has no options provided.");
                }


                if (question.getOptions() != null) {
                    for (QuestionOption option : question.getOptions()) {
                        option.setQuestion(question);
                    }
                }
            }

            // Verify that all positions from 1 to numberOfQuestions are present
            for (int i = 1; i <= numberOfQuestions; i++) {
                if (!positions.contains(i)) {
                    throw new IllegalArgumentException("Invalid positionInQuestionnaire in form");
                }
            }
        }
        this.questionnaireRepository.save(questionnaire);
    }

    @Transactional
    public void submitFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user) {
        // Explicitly fetch the questionnaire with its answers
        Questionnaire questionnaire = questionnaireRepository.findById(userFormAnswersDTO.formId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Questionnaire not found with id: " + userFormAnswersDTO.formId()));

        // Or use a custom query to fetch answers
        List<Answer> existingAnswers = answerRepository.findByAnswerQuestionnaireAndUserId(questionnaire, user.getId());

        if (!existingAnswers.isEmpty()) {
            // Collect all answer text IDs
            List<Integer> answerTextIds = existingAnswers.stream()
                    .flatMap(answer -> answer.getTexts().stream())
                    .map(AnswerText::getAnswerTextId)
                    .toList();

            // Collect all answer IDs
            List<Integer> answerIds = existingAnswers.stream()
                    .map(Answer::getAnswerId)
                    .toList();

            // Perform deletions
            answerTextRepository.deleteAllByIdInBatch(answerTextIds);
            answerRepository.deleteAllByIdInBatch(answerIds);
        }

        // Validate answers for each question in the questionnaire
        for (QuestionnaireSection section : questionnaire.getSections()) {
            // If the section data was fetched independently, skip it
            if (Boolean.TRUE.equals(section.getShouldFetchData())) {
                continue;
            }

            for (Question question : section.getQuestions()) {
                // Find the answer for the current question
                Optional<AnswerDTO> answerOptional = userFormAnswersDTO.answers().stream()
                        .filter(answerDTO -> answerDTO.questionId() == question.getId()).findFirst();

                // Check if the question is required and if it has been answered
                if (isRequiredQuestionUnanswered(question, answerOptional)) {
                    throw new IllegalArgumentException("All required questions must be answered.");
                }

                // Validate answerText for RADIO and CHECKBOX types
                if (isRadioOrCheckboxQuestion(question) && answerOptional.isPresent()) {
                    validateRadioOrCheckboxAnswer(question, answerOptional.get());
                }
            }
        }

        // Save the answers if all conditions are met
        saveFormAnswers(userFormAnswersDTO, user, questionnaire);
    }

    private boolean isRequiredQuestionUnanswered(Question question,
                                                 Optional<AnswerDTO> answerOptional) {
        return answerOptional.isEmpty() && !question.getOptional();
    }

    private boolean isRadioOrCheckboxQuestion(Question question) {
        return AnswerType.fromId(question.getAnswerType()) == AnswerType.RADIO
                || AnswerType.fromId(question.getAnswerType()) == AnswerType.CHECKBOX;
    }

    private void validateRadioOrCheckboxAnswer(Question question, AnswerDTO answerDTO) {
        for (AnswerTextDTO answerTextDTO : answerDTO.texts()) {
            boolean validAnswerText = question.getOptions().stream()
                    .anyMatch(option -> answerTextDTO.textOfAnswer().equals(option.getQuestionOption()));

            if (!validAnswerText) {
                throw new IllegalArgumentException(
                        "Answer text does not match available options for question: "
                                + question.getQuestionTitle());
            }
        }
    }

    public void updateFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user) {
        // Fetch the questionnaire by formId
        Questionnaire questionnaire = questionnaireRepository.findById(userFormAnswersDTO.formId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Questionnaire not found with id: " + userFormAnswersDTO.formId()));

        // Fetch and delete existing answers for the user and questionnaire
        List<Answer> existingAnswers =
                answerRepository.findByAnswerQuestionnaireAndUserId(questionnaire, user.getId());
        if (existingAnswers.isEmpty()) {
            throw new IllegalArgumentException(String.format(
                    "Questions for the questionnaire with ID %d for user with ID %d do not exist.",
                    userFormAnswersDTO.formId(), user.getId()));
        }

        answerRepository.deleteAll(existingAnswers);

        // Verify all questions are answered
        for (QuestionnaireSection section : questionnaire.getSections()) {
            for (Question question : section.getQuestions()) {
                boolean answered = userFormAnswersDTO.answers().stream()
                        .anyMatch(answerDTO -> answerDTO.questionId() == question.getId());
                if (!answered) {
                    throw new IllegalArgumentException("All questions must be answered.");
                }
            }
        }

        this.saveFormAnswers(userFormAnswersDTO, user, questionnaire);
    }

    @Override
    public boolean hasUserFilledForm(int formId, User user) {
        Optional<Questionnaire> questionnaire = this.questionnaireRepository.findById(formId);

        if (questionnaire.isEmpty()) {
            throw new IllegalArgumentException("Questionnaire with id " + formId + " does not exist.");
        }

        return this.answerRepository.existsByAnswerQuestionnaireAndUserId(questionnaire.get(), user);
    }

    @Override
    public String getMarkOfSubjectFromQuesionnaire(String subjectName, User user) {
        return questionnaireRepository.getAnswerOfQuestionByQuestionText(subjectName.toLowerCase(), user.getId());
    }

    @Override
    public List<Question> getMandatorySubjects(Long studyProgramId, int year) {
        // First fetch all the StudyProgramSubjects for the given parameters
        List<StudyProgramSubject> mandatorySubjects = this.studyProgramSubjectRepository.findMandatorySubjects(studyProgramId, year);
        // Now join the data with the question entity
        return this.questionRepository.findAllByQuestionIdentifierIn(mandatorySubjects.stream()
                .map(obj -> String.format("question_%s", obj.getSubject().getCode()))
                .toList());
    }

    @Override
    public QuestionnaireDTO getForm(int formId) {
        Questionnaire questionnaire = this.questionnaireRepository.findById(formId)
                .orElseThrow(() -> new IllegalArgumentException(
                        String.format("The questionnaire with the specified formId %d does not exist.", formId)));

        questionnaire.getSections().forEach(section ->
                section.getQuestions().sort(Comparator.comparing(Question::getPositionInQuestionnaire)));

        // Map to DTO inside the transactional context to ensure lazy collections are loaded
        return QuestionnaireMapper.INSTANCE.toDto(questionnaire);
    }

    @Transactional
    @Override
    public Questionnaire getUserFilledForm(int formId, Integer userId) {
        Session session = entityManager.unwrap(Session.class);
        session.enableFilter("answeredByUserFilter").setParameter("userId", userId);
        session.enableFilter("answeredQuestionByUserFilter").setParameter("userId", userId);

        Optional<Questionnaire> questionnaireOptional = this.questionnaireRepository.findById(formId);

        if (questionnaireOptional.isEmpty()) {
            throw new QuestionnaireNotFilledException(
                    String.format("The questionnaire with the specified formId %d does not exist.", formId));
        }

        int totalUserAnswers = questionnaireOptional.get().getSections().stream()
                .mapToInt(section -> section.getQuestions().size())
                .sum();

        if (totalUserAnswers == 0) {
            throw new QuestionnaireNotFilledException(
                    String.format("The questionnaire with the specified formId %d does not exist.", formId));
        }

        return questionnaireOptional.get();
    }

    private void saveFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user,
                                 Questionnaire questionnaire) {
        boolean isRegisteredStudent = user.getStudent() != null;
        int year = -1;
        int studyProgram = -1;
        for (AnswerDTO answerDTO : userFormAnswersDTO.answers()) {
            Question question = questionRepository.findById(answerDTO.questionId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Question not found with id: " + answerDTO.questionId()));

            // Set the new study year for the user
            if (question.getQuestionIdentifier().equals("question_rocnik")) {
                if (isRegisteredStudent) {
                    user.getStudent().setYear(Integer.valueOf(answerDTO.texts().getFirst().textOfAnswer()));
                } else {
                    year = Integer.parseInt(answerDTO.texts().getFirst().textOfAnswer());
                }
            }

            // Set the new study program for the user
            if (question.getQuestionIdentifier().equals("question_odbor")) {
                if (isRegisteredStudent) {
                    user.getStudent().setStudyProgramId(Integer.valueOf(answerDTO.texts().getFirst().textOfAnswer()));
                } else {
                    studyProgram = Integer.parseInt(answerDTO.texts().getFirst().textOfAnswer());
                }
            }

            Answer answer = AnswerMapper.INSTANCE.toEntity(answerDTO);
            answer.setUser(user);
            answer.setAnswerQuestionnaire(questionnaire);
            answer.setAnswerQuestion(question);

            for (AnswerText answerText : answer.getTexts()) {
                answerText.setAnswer(answer);
            }

            this.answerRepository.save(answer);
        }

        if (!isRegisteredStudent) {
            Student student = new Student();
            student.setUser(user);
            student.setStudyProgramId(studyProgram);
            student.setYear(year);
            this.studentRepository.save(student);
        }
    }
}
