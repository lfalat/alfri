package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionnaireSectionDTO;
import sk.uniza.fri.alfri.entity.QuestionnaireSection;

@Mapper(uses = QuestionMapper.class)
public interface QuestionnaireSectionMapper {
  QuestionnaireSectionMapper INSTANCE = Mappers.getMapper(QuestionnaireSectionMapper.class);

  QuestionnaireSection toEntity(QuestionnaireSectionDTO dto);

  QuestionnaireSectionDTO toDto(QuestionnaireSection dto);
}
