package sk.uniza.fri.alfri.service;

import org.springframework.data.domain.Page;
import sk.uniza.fri.alfri.dto.StudentFilterDTO;
import sk.uniza.fri.alfri.entity.StudentAvgMark;

public interface LeadService {
    Page<StudentAvgMark> getStudentPerformanceReport(StudentFilterDTO filter);
}
