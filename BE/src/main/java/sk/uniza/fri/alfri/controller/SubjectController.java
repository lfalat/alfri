package sk.uniza.fri.alfri.controller;

import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.uniza.fri.alfri.dto.SubjectDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.mapper.StudyProgramSubjectMapper;
import sk.uniza.fri.alfri.service.ISubjectService;

@RequestMapping("/api/subject")
@RestController
@Slf4j
public class SubjectController {
  private final ISubjectService subjectService;

  public SubjectController(ISubjectService subjectService) {
    this.subjectService = subjectService;
  }

  @GetMapping("/{studyProgramId}")
  public ResponseEntity<Page<SubjectDto>> findAllSubjectsByStudyProgramId(
      @PathVariable @Positive Integer studyProgramId,
      @RequestParam @PositiveOrZero Integer pageNumber,
      @RequestParam @Positive Integer pageSize) {
    log.info(
        "Getting all subjects on page {} with page size {} for study program with id {}",
        pageNumber,
        pageSize,
        studyProgramId);

    Page<StudyProgramSubject> subjects =
        subjectService.findAllByStudyProgramId(studyProgramId, pageNumber, pageSize);

    log.info(
        "{} subjects for study program with id {} on page {} with page size {} returned",
        subjects.getSize(),
        studyProgramId,
        pageNumber,
        pageSize);

    Page<SubjectDto> subjectDtos =
        subjects.map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectDto);

    return ResponseEntity.ok().body(subjectDtos);
  }
}
