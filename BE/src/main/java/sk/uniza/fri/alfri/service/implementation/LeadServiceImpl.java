package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityManager;
import org.hibernate.Session;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.dto.StudentFilterDTO;
import sk.uniza.fri.alfri.entity.StudentAvgMark;
import sk.uniza.fri.alfri.repository.StudentAvgMarkRepository;
import sk.uniza.fri.alfri.service.LeadService;

@Service
public class LeadServiceImpl implements LeadService {

    private final EntityManager entityManager;
    private final StudentAvgMarkRepository studentAvgMarkRepository;

    public LeadServiceImpl(EntityManager entityManager, StudentAvgMarkRepository studentAvgMarkRepository) {
        this.entityManager = entityManager;
        this.studentAvgMarkRepository = studentAvgMarkRepository;
    }

    @Override
    public Page<StudentAvgMark> getStudentPerformanceReport(StudentFilterDTO filterDTO) {
        Session session = this.entityManager.unwrap(Session.class);
        if (filterDTO.year() != null) {
            session.enableFilter("yearFilter").setParameter("year", filterDTO.year());
        }

        if (filterDTO.studyProgramId() != null) {
            session.enableFilter("studyProgramFilter").setParameter("studyProgramId", filterDTO.studyProgramId());
        }

        Pageable pageable = PageRequest.of(filterDTO.page(), filterDTO.size(), Sort.by(filterDTO.direction(), filterDTO.sortBy()));
        return this.studentAvgMarkRepository.findAll(pageable);
    }
}
