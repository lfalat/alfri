package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Question;

public interface QuestionRepository extends JpaRepository<Question, Integer> {
}
