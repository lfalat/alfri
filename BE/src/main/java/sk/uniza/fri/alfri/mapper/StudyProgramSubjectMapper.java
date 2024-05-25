package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

@Mapper
public interface StudyProgramSubjectMapper {
  StudyProgramSubjectMapper INSTANCE = Mappers.getMapper(StudyProgramSubjectMapper.class);

  @Mapping(target = "name", source = "studyProgramSubject.id.subject.name")
  @Mapping(target = "code", source = "studyProgramSubject.id.subject.code")
  @Mapping(target = "abbreviation", source = "studyProgramSubject.id.subject.abbreviation")
  @Mapping(target = "obligation", source = "studyProgramSubject.obligation")
  @Mapping(target = "studyProgramName", source = "studyProgramSubject.id.studyProgram.name")
  @Mapping(target = "recommendedYear", source = "studyProgramSubject.recommendedYear")
  @Mapping(
      target = "semester",
      source = "studyProgramSubject.semesterWinter",
      qualifiedByName = "mapSemester")
  SubjectDto studyProgramSubjectToSubjectDto(StudyProgramSubject studyProgramSubject);

  @Named("mapSemester")
  default String mapSemester(Boolean semesterWinter) {
    return semesterWinter != null && semesterWinter ? "Zimný" : "Letný";
  }
}
