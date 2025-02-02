package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.UserFormAnswersDTO;
import sk.uniza.fri.alfri.entity.Question;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.User;

import java.util.List;
import java.util.Optional;


public interface FormService {
  void saveQuestionnaire(QuestionnaireDTO questionnaireDTO);

  void submitFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user);

  void updateFormAnswers(UserFormAnswersDTO userFormAnswersDTO, User user);

  boolean hasUserFilledForm(int formId, User user);

  String getMarkOfSubjectFromQuesionnaire(String subjectName, User user);

  List<Question> getMandatorySubjects(Long studyProgramId, int year);

  Questionnaire getForm(int formId);

  Questionnaire getUserFilledForm(int formId, Integer userId);
}

