package sk.uniza.fri.alfri.mapper;

import org.mapstruct.*;
import sk.uniza.fri.alfri.dto.StudyProgramDto;
import sk.uniza.fri.alfri.entity.StudyProgram;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = MappingConstants.ComponentModel.SPRING)
public interface StudyProgramMapper {
  StudyProgram toEntity(StudyProgramDto studyProgramDto);

  StudyProgramDto toDto(StudyProgram studyProgram);

  @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
  StudyProgram partialUpdate(StudyProgramDto studyProgramDto,
      @MappingTarget StudyProgram studyProgram);
}
