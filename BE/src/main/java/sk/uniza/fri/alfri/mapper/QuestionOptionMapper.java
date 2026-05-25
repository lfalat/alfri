package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionOptionDTO;
import sk.uniza.fri.alfri.entity.QuestionOption;

@Mapper
public interface QuestionOptionMapper {
    QuestionOptionMapper INSTANCE = Mappers.getMapper(QuestionOptionMapper.class);

    QuestionOption toEntity(QuestionOptionDTO dto);

    QuestionOptionDTO toDto(QuestionOption dto);
}
