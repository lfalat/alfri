package sk.uniza.fri.alfri.service.implementation;

import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerDTO;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerTextDTO;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerType;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.AnswerText;
import sk.uniza.fri.alfri.entity.Question;
import sk.uniza.fri.alfri.entity.QuestionOption;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.QuestionnaireSection;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.AnswerMapper;
import sk.uniza.fri.alfri.mapper.QuestionnaireMapper;
import sk.uniza.fri.alfri.repository.AnswerRepository;
import sk.uniza.fri.alfri.repository.AnswerTextRepository;
import sk.uniza.fri.alfri.repository.QuestionRepository;
import sk.uniza.fri.alfri.repository.QuestionnaireRepository;
import sk.uniza.fri.alfri.service.FormService;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
public class FormServiceImpl implements FormService {
    private final QuestionnaireRepository questionnaireRepository;
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;

    public FormServiceImpl(QuestionnaireRepository questionnaireRepository, QuestionRepository questionRepository, AnswerRepository answerRepository, AnswerTextRepository answerTextRepository) {
        this.questionnaireRepository = questionnaireRepository;
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
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
                    throw new IllegalArgumentException("Duplicate questionIdentifier: " + question.getQuestionIdentifier());
                }

                // Check if position is within the valid range and not a duplicate
                if (position < 1 || position > numberOfQuestions || !positions.add(position)) {
                    throw new IllegalArgumentException("Invalid positionInQuestionnaire in form");
                }

                question.setQuestionnaireSection(section);

                // Validate options for non-optional questions
                if (Boolean.TRUE.equals(!question.getOptional()) && (question.getOptions() == null || question.getOptions().isEmpty())) {
                    throw new IllegalArgumentException("Question with identifier '" + question.getQuestionIdentifier() + "' is not optional but has no options provided.");
                }

                for (QuestionOption option : question.getOptions()) {
                    option.setQuestion(question);
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

    public void submitFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user) {
        // Fetch the questionnaire by formId
        Questionnaire questionnaire = questionnaireRepository.findById(userFormAnswersDTO.formId())
                .orElseThrow(() -> new ResourceNotFoundException("Questionnaire not found with id: " + userFormAnswersDTO.formId()));

        // Check if the user has already submitted answers for this questionnaire
        if (answerRepository.existsByAnswerQuestionnaireAndUserId(questionnaire, user)) {
            throw new IllegalArgumentException("User has already submitted answers for this questionnaire.");
        }

        // Validate answers for each question in the questionnaire
        for (QuestionnaireSection section : questionnaire.getSections()) {
            for (Question question : section.getQuestions()) {
                // Find the answer for the current question
                Optional<AnswerDTO> answerOptional = userFormAnswersDTO.answers().stream()
                        .filter(answerDTO -> answerDTO.questionId() == question.getId())
                        .findFirst();

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

    private boolean isRequiredQuestionUnanswered(Question question, Optional<AnswerDTO> answerOptional) {
        return answerOptional.isEmpty() && !question.getOptional();
    }

    private boolean isRadioOrCheckboxQuestion(Question question) {
        return AnswerType.fromId(question.getAnswerType()) == AnswerType.RADIO ||
                AnswerType.fromId(question.getAnswerType()) == AnswerType.CHECKBOX;
    }

    private void validateRadioOrCheckboxAnswer(Question question, AnswerDTO answerDTO) {
        for (AnswerTextDTO answerTextDTO : answerDTO.texts()) {
            boolean validAnswerText = question.getOptions().stream()
                    .anyMatch(option -> option.getQuestionOption().equals(answerTextDTO.answerText()));

            if (!validAnswerText) {
                throw new IllegalArgumentException("Answer text does not match available options for question: " + question.getQuestionTitle());
            }
        }
    }

    public void updateFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user) {
        // Fetch the questionnaire by formId
        Questionnaire questionnaire = questionnaireRepository.findById(userFormAnswersDTO.formId())
                .orElseThrow(() -> new ResourceNotFoundException("Questionnaire not found with id: " + userFormAnswersDTO.formId()));

        // Fetch and delete existing answers for the user and questionnaire
        List<Answer> existingAnswers = answerRepository.findByAnswerQuestionnaireAndUserId(questionnaire, user);
        if (existingAnswers.isEmpty()) {
            throw new IllegalArgumentException(String.format(
                    "Questions for the questionnaire with ID %d for user with ID %d do not exist.",
                    userFormAnswersDTO.formId(), user.getId()
            ));
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

    private void saveFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user, Questionnaire questionnaire) {
        for (AnswerDTO answerDTO : userFormAnswersDTO.answers()) {
            Question question = questionRepository.findById(answerDTO.questionId())
                    .orElseThrow(() -> new ResourceNotFoundException("Question not found with id: " + answerDTO.questionId()));

            Answer answer = AnswerMapper.INSTANCE.toEntity(answerDTO);
            answer.setUserId(user);
            answer.setAnswerQuestionnaire(questionnaire);
            answer.setAnswerQuestion(question);

            for (AnswerText answerText : answer.getTexts()) {
                answerText.setAnswer(answer);
            }

            this.answerRepository.save(answer);
        }
    }

}
