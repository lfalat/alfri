package sk.uniza.fri.alfri.mapper;

import org.mapstruct.*;
import org.mapstruct.MappingConstants.ComponentModel;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.focus.FocusDTO;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;

@Mapper(componentModel = ComponentModel.SPRING)
public interface SubjectMapper {
  SubjectMapper INSTANCE = Mappers.getMapper(SubjectMapper.class);

    @Mapping(target = "semester", ignore = true)
    @Mapping(source = "focus", target = "focusDTO")
    default SubjectExtendedDto toCustomSubjectExtendedDto(Subject subject) {
        if (isCustomPropertyPresent(subject)) {
            StudyProgramSubject studyProgramSubject = subject.getStudyProgramSubjects().getFirst();

            return new SubjectExtendedDto(
                    subject.getName(),
                    subject.getCode(),
                    subject.getAbbreviation(),
                    studyProgramSubject.getObligation(),
                    studyProgramSubject.getId().getStudyProgram().getName(),
                    mapSemester(studyProgramSubject.getSemesterWinter()),
                    studyProgramSubject.getRecommendedYear(),
                    subject.getFocus() != null ? toFocusDTO(subject.getFocus()) : null
            );
        } else {
            return toSubjectExtendedDto(subject);
        }
    }

    @Condition
    default boolean isCustomPropertyPresent(Subject studyProgram) {
        return studyProgram.getStudyProgramSubjects() != null && !studyProgram.getStudyProgramSubjects().isEmpty();
    }

    @Named("mapSemester")
    default String mapSemester(Boolean semesterWinter) {
        return semesterWinter != null && semesterWinter ? "Zimný" : "Letný";
    }

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

  @Mapping(target = "studyProgramName", ignore = true)
  @Mapping(target = "semester", ignore = true)
  @Mapping(target = "recommendedYear", ignore = true)
  @Mapping(target = "obligation", ignore = true)
  SubjectDto toDto(Subject subject);

  @Mapping(target = "id", ignore = true)
  @Mapping(target = "focus", source = "subjectExtendedDto.focusDTO")
  Subject fromSubjectExtendedDtotoEntity(SubjectExtendedDto subjectExtendedDto);

  @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
  Subject partialUpdate(SubjectDto subjectDto, @MappingTarget Subject subject);
}
