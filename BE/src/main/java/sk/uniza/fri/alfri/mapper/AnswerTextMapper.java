package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerTextDTO;
import sk.uniza.fri.alfri.entity.AnswerText;

@Mapper
public interface AnswerTextMapper {
    AnswerTextMapper INSTANCE = Mappers.getMapper(AnswerTextMapper.class);

    AnswerText toEntity(AnswerTextDTO dto);

    AnswerTextDTO toDto(AnswerText dto);
}
