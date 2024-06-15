package sk.uniza.fri.alfri.service.implementation;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.repository.StudyProgramSubjectRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.service.ISubjectService;

@Service
public class SubjectService implements ISubjectService {
    private final StudyProgramSubjectRepository studyProgramSubjectRepository;
    private final SubjectRepository subjectRepository;


    public SubjectService(StudyProgramSubjectRepository studyProgramSubjectRepository, SubjectRepository subjectRepository) {
        this.studyProgramSubjectRepository = studyProgramSubjectRepository;
        this.subjectRepository = subjectRepository;
    }

    @Override
    public Page<StudyProgramSubject> findAllByStudyProgramId(
            SearchDefinition searchDefinition, PageDefinition pageDefinition) {
        return this.studyProgramSubjectRepository.findAllByFilter(searchDefinition, pageDefinition);
    }

    @Override
    public Subject findBySubjectCode(String subjectCode) {
        return this.subjectRepository.findSubjectByCode(subjectCode);
    }
}
