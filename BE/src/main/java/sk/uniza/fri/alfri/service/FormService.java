package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.User;

public interface FormService {
  void saveQuestionnaire(QuestionnaireDTO questionnaireDTO);

  void submitFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user);

  void updateFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user);

  void hasUserFilledForm(int formId, User user);
}

