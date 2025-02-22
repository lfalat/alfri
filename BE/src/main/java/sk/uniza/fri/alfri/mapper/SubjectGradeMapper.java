package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.SubjectGradeDto;
import sk.uniza.fri.alfri.entity.SubjectGrade;

@Mapper(uses = SubjectMapper.class)
public interface SubjectGradeMapper {
    SubjectGradeMapper INSTANCE = Mappers.getMapper(SubjectGradeMapper.class);

    SubjectGrade toEntity(SubjectGradeDto subjectGradeDto);

    SubjectGradeDto toDto(SubjectGrade subjectGrade);
}
