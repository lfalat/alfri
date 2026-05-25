package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.dto.subject.SubjectWithCountDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

@Mapper
public interface StudyProgramSubjectMapper {
    StudyProgramSubjectMapper INSTANCE = Mappers.getMapper(StudyProgramSubjectMapper.class);

    @Mapping(target = "id", source = "studyProgramSubject.subject.id")
    @Mapping(target = "name", source = "studyProgramSubject.subject.name")
    @Mapping(target = "code", source = "studyProgramSubject.subject.code")
    @Mapping(target = "abbreviation", source = "studyProgramSubject.subject.abbreviation")
    @Mapping(target = "obligation", source = "studyProgramSubject.obligation")
    @Mapping(target = "studyProgramName", source = "studyProgramSubject.studyProgram.name")
    @Mapping(target = "recommendedYear", source = "studyProgramSubject.recommendedYear")
    @Mapping(target = "semester", source = "studyProgramSubject.semesterWinter",
            qualifiedByName = "mapSemester")
    SubjectDto studyProgramSubjectToSubjectDto(StudyProgramSubject studyProgramSubject);

    @Mapping(target = "id", source = "dto.studyProgramSubject.subject.id")
    @Mapping(target = "name", source = "dto.studyProgramSubject.subject.name")
    @Mapping(target = "code", source = "dto.studyProgramSubject.subject.code")
    @Mapping(target = "abbreviation", source = "dto.studyProgramSubject.subject.abbreviation")
    @Mapping(target = "obligation", source = "dto.studyProgramSubject.obligation")
    @Mapping(target = "studyProgramName", source = "dto.studyProgramSubject.studyProgram.name")
    @Mapping(target = "recommendedYear", source = "dto.studyProgramSubject.recommendedYear")
    @Mapping(target = "semester", source = "dto.studyProgramSubject.semesterWinter",
            qualifiedByName = "mapSemester")
    @Mapping(target = "studentCount", source = "dto.studentCount")
    SubjectDto subjectWithCountDtoToSubjectDto(SubjectWithCountDto dto);

    @Mapping(target = "id", source = "studyProgramSubject.subject.id")
    @Mapping(target = "studyProgramName", source = "studyProgramSubject.studyProgram.name")
    @Mapping(target = "semester", source = "studyProgramSubject.semesterWinter",
            qualifiedByName = "mapSemester")
    @Mapping(target = "name", source = "studyProgramSubject.subject.name")
    @Mapping(target = "focusDTO", source = "studyProgramSubject.subject.focus")
    @Mapping(target = "code", source = "studyProgramSubject.subject.code")
    @Mapping(target = "abbreviation", source = "studyProgramSubject.subject.abbreviation")
    @Mapping(target = "obligation", source = "studyProgramSubject.obligation")
    @Mapping(target = "recommendedYear", source = "studyProgramSubject.recommendedYear")
    SubjectExtendedDto studyProgramSubjectToSubjectExtendedDto(
            StudyProgramSubject studyProgramSubject);

    @Named("mapSemester")
    default String mapSemester(Boolean semesterWinter) {
        return semesterWinter != null && semesterWinter ? "Zimný" : "Letný";
    }
}
