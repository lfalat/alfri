package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.QuestionnaireSection;

import java.util.Optional;

public interface QuestionnaireSectionRepository extends JpaRepository<QuestionnaireSection, Integer> {
    
    @Query("SELECT qs FROM QuestionnaireSection qs WHERE qs.questionnaire.id = :questionnaireId AND qs.shouldFetchData = true")
    Optional<QuestionnaireSection> findDynamicSectionByQuestionnaireId(@Param("questionnaireId") Integer questionnaireId);
}

