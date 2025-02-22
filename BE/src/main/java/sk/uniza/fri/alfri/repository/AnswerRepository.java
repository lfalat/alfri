package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.Answer;
import sk.uniza.fri.alfri.entity.Questionnaire;
import sk.uniza.fri.alfri.entity.User;

import java.util.List;

public interface AnswerRepository extends JpaRepository<Answer, Integer> {
    boolean existsByAnswerQuestionnaireAndUserId(Questionnaire questionnaire, User user);

    List<Answer> findByAnswerQuestionnaireAndUserId(Questionnaire questionnaire, Integer user);

    @Query("SELECT a FROM Answer a WHERE a.answerQuestion.id IN :questionIds AND a.user = :user")
    List<Answer> findByQuestionIdsAndUser(@Param("questionIds") List<Integer> questionIds,
                                          @Param("user") User user);
}
