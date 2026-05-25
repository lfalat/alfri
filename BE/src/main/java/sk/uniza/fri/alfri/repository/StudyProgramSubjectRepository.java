package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.dto.subject.SubjectWithCountDto;

import java.util.List;
import java.util.Optional;

public interface StudyProgramSubjectRepository {
    Page<StudyProgramSubject> findAllByFilter(SearchDefinition searchDefinition,
                                              PageDefinition pageDefinition);

    Optional<StudyProgramSubject> findByIdSubjectId(Integer id, Integer studyProgramId);

    List<StudyProgramSubject> findMandatorySubjects(Long studyProgramId, int year);

    Page<SubjectWithCountDto> findMostPopularElectiveSubjects(PageDefinition pageDefinition);
}
