package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.User;

import java.util.List;

public interface AnswerRepository extends JpaRepository<Answer, Integer> {
    boolean existsByAnswerQuestionnaireAndUserId(Questionnaire questionnaire, User user);
    List<Answer> findByAnswerQuestionnaireAndUserId(Questionnaire questionnaire, User user);}
