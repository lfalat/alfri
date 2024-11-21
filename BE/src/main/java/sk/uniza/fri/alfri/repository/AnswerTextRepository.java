package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.AnswerText;

public interface AnswerTextRepository extends JpaRepository<AnswerText, Integer> {
}
