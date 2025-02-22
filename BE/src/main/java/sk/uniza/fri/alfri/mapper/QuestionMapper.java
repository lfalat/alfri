package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.questionnaire.AnswerType;
import sk.uniza.fri.alfri.dto.questionnaire.AnsweredQuestionDTO;
import sk.uniza.fri.alfri.dto.questionnaire.QuestionDTO;
import sk.uniza.fri.alfri.entity.Question;

@Mapper(uses = QuestionOptionMapper.class)
public interface QuestionMapper {
    QuestionMapper INSTANCE = Mappers.getMapper(QuestionMapper.class);

    @Named("intToEnum")
    default AnswerType intToEnum(int id) {
        return AnswerType.fromId(id);
    }

    @Named("enumToInt")
    default int enumToInt(AnswerType answerType) {
        return answerType.getId();
    }

    @Mapping(target = "answerType", source = "answerType", qualifiedByName = "enumToInt")
    @Mapping(target = "id", ignore = true)
    Question toEntity(QuestionDTO dto);

    @Mapping(target = "answerType", source = "answerType", qualifiedByName = "intToEnum")
    @Mapping(target = "id", source = "id")
    QuestionDTO toDto(Question dto);

    @Mapping(target = "answerType", source = "answerType", qualifiedByName = "intToEnum")
    AnsweredQuestionDTO toAnsweredDto(Question dto);
}
