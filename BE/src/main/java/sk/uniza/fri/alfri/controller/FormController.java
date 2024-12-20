package sk.uniza.fri.alfri.controller;

import java.util.Optional;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.QuestionnaireMapper;
import sk.uniza.fri.alfri.repository.QuestionnaireRepository;
import sk.uniza.fri.alfri.service.FormService;
import sk.uniza.fri.alfri.service.UserService;
import sk.uniza.fri.alfri.service.implementation.AuthService;
import sk.uniza.fri.alfri.service.implementation.JwtService;

@RestController
@RequestMapping("/api/form")
@PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN'})")
@Slf4j
public class FormController {

  private final QuestionnaireRepository questionnaireRepository;

  private final FormService formService;

  private final JwtService jwtService;

  private final UserService userService;
  private final AuthService authService;

  public FormController(QuestionnaireRepository questionnaireRepository, FormService formService,
      JwtService jwtService, UserService userService, AuthService authService) {
    this.questionnaireRepository = questionnaireRepository;
    this.formService = formService;
    this.jwtService = jwtService;
    this.userService = userService;
    this.authService = authService;
  }

  @PostMapping(value = "/add-form", consumes = MediaType.APPLICATION_JSON_VALUE)
  public void parseJson(@RequestBody QuestionnaireDTO questionnaireDTO) {
    this.formService.saveQuestionnaire(questionnaireDTO);
  }

  @GetMapping(value = "/get-form/{formId}", produces = MediaType.APPLICATION_JSON_VALUE)
  public QuestionnaireDTO getForm(@PathVariable int formId) throws IllegalArgumentException {
    Optional<Questionnaire> questionnaire = this.questionnaireRepository.findById(formId);

    if (questionnaire.isEmpty()) {
      throw new IllegalArgumentException(
          String.format("The questionnaire with the specified formId %d does not exist.", formId));
    }

    return QuestionnaireMapper.INSTANCE.toDto(questionnaire.get());
  }

  @PostMapping(value = "/submit-form", consumes = MediaType.APPLICATION_JSON_VALUE)
  public void submitForm(@RequestHeader(value = "Authorization") String token,
      @RequestBody UserFormAnswersDTO userFormAnswersDTO) {
    // Get user id
    String parsedToken = token.replace("Bearer ", "");
    String username = this.jwtService.extractUsername(parsedToken);
    User user = this.userService.getUser(username);

    this.formService.submitFormAnswers(userFormAnswersDTO, user);
  }

  @PutMapping(value = "/replace-form", consumes = MediaType.APPLICATION_JSON_VALUE)
  public void replaceForm(@RequestHeader(value = "Authorization") String token,
      @RequestBody UserFormAnswersDTO userFormAnswersDTO) {
    // Get user id
    String parsedToken = token.replace("Bearer ", "");
    String username = this.jwtService.extractUsername(parsedToken);
    User user = this.userService.getUser(username);

    this.formService.updateFormAnswers(userFormAnswersDTO, user);
  }

  @GetMapping(value = "/has-filled-form/{formId}")
  public void hasUserFilledForm(@PathVariable int formId) throws IllegalArgumentException {
    Optional<String> email = this.authService.getCurrentUserEmail();

    if (email.isEmpty()) {
      throw new IllegalArgumentException("Can't parse user email from token");
    }

    User user = this.userService.getUser(email.get());
    this.formService.hasUserFilledForm(formId, user);
  }
}
