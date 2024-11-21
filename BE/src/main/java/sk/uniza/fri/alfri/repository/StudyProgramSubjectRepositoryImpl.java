package sk.uniza.fri.alfri.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PageableAssembler;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchSpecification;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

@Service
public class StudyProgramSubjectRepositoryImpl implements StudyProgramSubjectRepository {
  private final StudyProgramSubjectSpringDataRepository studyProgramSubjectSpringDataRepository;

  public StudyProgramSubjectRepositoryImpl(
      StudyProgramSubjectSpringDataRepository studyProgramSubjectSpringDataRepository) {
    this.studyProgramSubjectSpringDataRepository = studyProgramSubjectSpringDataRepository;
  }

  @Override
  public Page<StudyProgramSubject> findAllByFilter(
      SearchDefinition searchDefinition, PageDefinition pageDefinition) {

    Pageable pageable = PageableAssembler.from(pageDefinition);

    SearchSpecification<StudyProgramSubject> specification =
        new SearchSpecification<>(searchDefinition.getSearchCriteria());

    return this.studyProgramSubjectSpringDataRepository.findAll(specification, pageable);
  }

  @Override
  public Optional<StudyProgramSubject> findByIdSubjectId(Integer id) {
    return studyProgramSubjectSpringDataRepository.findByIdSubjectId(id);
  }
}
