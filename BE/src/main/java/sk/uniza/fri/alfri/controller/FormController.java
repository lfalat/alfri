package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.questionnaire.AnsweredQuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionDTO;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.Question;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.QuestionMapper;
import sk.uniza.fri.alfri.mapper.QuestionnaireMapper;
import sk.uniza.fri.alfri.service.FormService;
import sk.uniza.fri.alfri.service.implementation.AuthService;

import java.util.List;

@RestController
@RequestMapping("/api/form")
@PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE'})")
@Slf4j
public class FormController {

    private final FormService formService;
    private final AuthService authService;

    public FormController(
            FormService formService, AuthService authService
    ) {
        this.formService = formService;
        this.authService = authService;
    }

    @PostMapping(value = "/add-form", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void parseJson(@RequestBody QuestionnaireDTO questionnaireDTO) {
        this.formService.saveQuestionnaire(questionnaireDTO);
    }

  @GetMapping(value = "/get-form/{formId}", produces = MediaType.APPLICATION_JSON_VALUE)
  public QuestionnaireDTO getForm(@PathVariable int formId) throws IllegalArgumentException {
      return this.formService.getForm(formId);
  }

    @GetMapping(value = "/get-user-answers/{formId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public AnsweredQuestionnaireDTO getUserAnsweredForm(@PathVariable int formId) throws IllegalArgumentException {
        User user = this.authService.getCurrentUser()
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));

        if (user == null) {
            log.error("Current user not found");
            throw new IllegalArgumentException("Current user not found");
        }

        Questionnaire questionnaire = this.formService.getUserFilledForm(formId, user.getId());
        return QuestionnaireMapper.INSTANCE.toAnsweredDto(questionnaire);
    }

    @PostMapping(value = "/submit-form", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void submitForm(@RequestBody UserFormAnswersDTO userFormAnswersDTO) {
        User user = this.authService.getCurrentUser()
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));

        this.formService.submitFormAnswers(userFormAnswersDTO, user);
    }

    @PutMapping(value = "/replace-form", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void replaceForm(@RequestBody UserFormAnswersDTO userFormAnswersDTO) {
        User user = this.authService.getCurrentUser()
                .orElseThrow(() -> new IllegalArgumentException("Current user not found"));

        this.formService.updateFormAnswers(userFormAnswersDTO, user);
    }

    @GetMapping(value = "/get-mandatory-subjects/{studyProgramId}/{year}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<QuestionDTO> getMandatorySubjects(@PathVariable Long studyProgramId, @PathVariable int year) {
        List<Question> mandatorySubjectsQuestions = this.formService.getMandatorySubjects(studyProgramId, year);
        return mandatorySubjectsQuestions.stream().map(QuestionMapper.INSTANCE::toDto).toList();
    }
}
