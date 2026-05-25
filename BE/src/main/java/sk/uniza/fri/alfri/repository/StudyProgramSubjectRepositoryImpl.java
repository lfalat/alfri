package sk.uniza.fri.alfri.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PageableAssembler;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchSpecification;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.dto.subject.SubjectWithCountDto;

import java.util.List;
import java.util.Optional;

@Service
public class StudyProgramSubjectRepositoryImpl implements StudyProgramSubjectRepository {
    private final StudyProgramSubjectSpringDataRepository studyProgramSubjectSpringDataRepository;

    public StudyProgramSubjectRepositoryImpl(
            StudyProgramSubjectSpringDataRepository studyProgramSubjectSpringDataRepository) {
        this.studyProgramSubjectSpringDataRepository = studyProgramSubjectSpringDataRepository;
    }

    @Override
    public Page<StudyProgramSubject> findAllByFilter(SearchDefinition searchDefinition,
                                                     PageDefinition pageDefinition) {

        Pageable pageable = PageableAssembler.from(pageDefinition);

        SearchSpecification<StudyProgramSubject> specification =
                new SearchSpecification<>(searchDefinition.getSearchCriteria());

        return this.studyProgramSubjectSpringDataRepository.findAll(specification, pageable);
    }

    @Override
    public Optional<StudyProgramSubject> findByIdSubjectId(Integer id, Integer studyProgramId) {
        return studyProgramSubjectSpringDataRepository.findBySubject_IdAndStudyProgram_Id(id, studyProgramId);
    }

    @Override
    public List<StudyProgramSubject> findMandatorySubjects(Long studyProgramId, int year) {
        return this.studyProgramSubjectSpringDataRepository.findAllMandatorySubjectsForStudyProgramAndYear(studyProgramId, year);
    }

    @Override
    public Page<SubjectWithCountDto> findMostPopularElectiveSubjects(PageDefinition pageDefinition) {
        Pageable pageable = PageableAssembler.from(pageDefinition);
        return this.studyProgramSubjectSpringDataRepository.findMostPopularElectiveSubjects(pageable);
    }
}
