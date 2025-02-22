package sk.uniza.fri.alfri.repository;

import jakarta.validation.constraints.NotBlank;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Question;

import java.util.Collection;
import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Integer> {
    List<Question> findAllByQuestionIdentifierIn(Collection<@NotBlank(message = "Question's identifier cannot be blank or null!") String> questionIdentifier);

    Question findQuestionByQuestionIdentifier(String code);
}
