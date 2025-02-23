package sk.uniza.fri.alfri.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.KeywordDTO;
import sk.uniza.fri.alfri.dto.StudentAverageGradeDTO;
import sk.uniza.fri.alfri.dto.StudentFilterDTO;
import sk.uniza.fri.alfri.dto.StudentYearCountDTO;
import sk.uniza.fri.alfri.dto.focus.FocusCategorySumDTO;
import sk.uniza.fri.alfri.entity.StudentAvgMark;
import sk.uniza.fri.alfri.mapper.StudentAvgMarkMapper;
import sk.uniza.fri.alfri.service.LeadService;
import sk.uniza.fri.alfri.service.implementation.SubjectService;

import java.util.List;

@RestController
@RequestMapping("/api/lead")
@PreAuthorize("hasAnyRole({'ROLE_VEDENIE'})")
public class LeadController {
    private final SubjectService subjectService;
    private final LeadService leadService;

    public LeadController(SubjectService subjectService, LeadService leadService) {
        this.subjectService = subjectService;
        this.leadService = leadService;
    }

    @GetMapping("/all-keywords")
    public ResponseEntity<List<KeywordDTO>> getAllKeywords() {
        List<KeywordDTO> keywordDTOS = this.subjectService.getAllKeywords();
        return ResponseEntity.ok(keywordDTOS);
    }

    @GetMapping("/counts-by-year")
    public ResponseEntity<List<StudentYearCountDTO>> getStudentCountsByYear() {
        return ResponseEntity.ok(this.subjectService.getStudentCountsByYear());
    }

    @GetMapping("/category-sums")
    public ResponseEntity<List<FocusCategorySumDTO>> getCategorySums() {
        List<FocusCategorySumDTO> focusCategorySumDTOS = this.subjectService.getMostPopularFocuses();
        return ResponseEntity.ok().body(focusCategorySumDTOS);
    }

    @GetMapping("/report/student-performance")
    public ResponseEntity<Page<StudentAverageGradeDTO>> getStudentPerformanceReport(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "100") int size,
            @RequestParam(defaultValue = "avgMark") String sortBy,
            @RequestParam(defaultValue = "DESC") Sort.Direction direction,
            @RequestParam(required = false) Integer studyProgramId,
            @RequestParam(required = false) Integer year
    ) {
        StudentFilterDTO filter = new StudentFilterDTO(studyProgramId, year, page, size, sortBy, direction);
        Page<StudentAvgMark> studentAvgMarks = this.leadService.getStudentPerformanceReport(filter);
        Page<StudentAverageGradeDTO> response = studentAvgMarks.map(StudentAvgMarkMapper.INSTANCE::toDto);
        return ResponseEntity.ok().body(response);
    }
}
