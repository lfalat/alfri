package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Questionnaire;

public interface QuestionnaireRepository extends JpaRepository<Questionnaire, Integer> {
}
