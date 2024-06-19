package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.focus.FocusDTO;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.Subject;

@Mapper
public interface SubjectMapper {
  SubjectMapper INSTANCE = Mappers.getMapper(SubjectMapper.class);

  @Mapping(target = "studyProgramName", ignore = true)
  @Mapping(target = "semester", ignore = true)
  @Mapping(target = "recommendedYear", ignore = true)
  @Mapping(target = "obligation", ignore = true)
  @Mapping(source = "focus", target = "focusDTO")

  SubjectExtendedDto toSubjectExtendedDto(Subject studyProgram);

  FocusDTO toFocusDTO(Focus focus);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "focus", ignore = true)
  Subject toEntity(SubjectDto subjectDto);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "focus", source = "subjectExtendedDto.focusDTO")
  Subject fromSubjectExtendedDtotoEntity(SubjectExtendedDto subjectExtendedDto);
}
