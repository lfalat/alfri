package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.Questionnaire;

public interface QuestionnaireRepository extends JpaRepository<Questionnaire, Integer> {

    @Query(nativeQuery = true, value = """
            SELECT
                COALESCE(at.answer_text, '*') AS answer_text
            FROM
                public.answer a
            JOIN
                public.question q ON a.question_id = q.question_id
            JOIN
                public.user u ON a.user_id = u.user_id
            LEFT JOIN
                public.answer_text at ON a.answer_id = at.answer_id
            WHERE
                q.question_title = :questionText
            AND
                a.user_id = :userId
            AND
                a.answer_id = (
                    SELECT MAX(a2.answer_id)
                    FROM public.answer a2
                    WHERE a2.question_id = q.question_id
                      AND a2.user_id = a.user_id
                )
            LIMIT 1;
            """)
    String getAnswerOfQuestionByQuestionText(@Param("questionText") String questionText,
                                             @Param("userId") Integer userId);
}
