package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerDTO;
import sk.uniza.fri.alfri.entity.Answer;

@Mapper(uses = AnswerTextMapper.class)
public interface AnswerMapper {
    AnswerMapper INSTANCE = Mappers.getMapper(AnswerMapper.class);

    Answer toEntity(AnswerDTO dto);

    AnswerDTO toDto(Answer dto);
}
