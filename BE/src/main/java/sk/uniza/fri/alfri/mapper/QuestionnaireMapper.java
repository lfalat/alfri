package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.AnsweredQuestionnaireDTO;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireDTO;
import sk.uniza.fri.alfri.entity.Questionnaire;

@Mapper(uses = {QuestionnaireSectionMapper.class})
public interface QuestionnaireMapper {
    QuestionnaireMapper INSTANCE = Mappers.getMapper(QuestionnaireMapper.class);

    Questionnaire toEntity(QuestionnaireDTO dto);

    QuestionnaireDTO toDto(Questionnaire dto);

    AnsweredQuestionnaireDTO toAnsweredDto(Questionnaire dto);

}
