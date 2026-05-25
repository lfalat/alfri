package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.StudentAverageGradeDTO;
import sk.uniza.fri.alfri.entity.StudentAvgMark;

@Mapper
public interface StudentAvgMarkMapper {
    StudentAvgMarkMapper INSTANCE = Mappers.getMapper(StudentAvgMarkMapper.class);

    @Mapping(source = "student.year", target = "year")
    @Mapping(source = "student.studyProgramId", target = "studyProgramId")
    StudentAverageGradeDTO toDto(StudentAvgMark entity);

    StudentAvgMark toEntity(StudentAverageGradeDTO dto);
}
