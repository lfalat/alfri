package sk.uniza.fri.alfri.controller;

import java.time.Duration;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PagitationRequestQuery;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortRequestQuery;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.mapper.StudyProgramSubjectMapper;
import sk.uniza.fri.alfri.mapper.SubjectMapper;
import sk.uniza.fri.alfri.service.ISubjectService;

@RequestMapping("/api/subject")
@RestController
@Slf4j
public class SubjectController {
  private final ISubjectService subjectService;

  public SubjectController(ISubjectService subjectService) {
    this.subjectService = subjectService;
  }

  @GetMapping(
      produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Page<SubjectDto>> findAllSubjectsByStudyProgramId(
      PagitationRequestQuery pagitationRequestQuery) {
    log.info(
        "Getting all subjects on page {} with page size {} with filters {}",
        pagitationRequestQuery.page,
        pagitationRequestQuery.size,
        pagitationRequestQuery.search);

    SearchDefinition searchDefinition = new SearchDefinition(pagitationRequestQuery.search);
    SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
    PageDefinition pageDefinition =
        new PageDefinition(pagitationRequestQuery.page, pagitationRequestQuery.size, sortDefinition);

    Page<StudyProgramSubject> subjects =
        subjectService.findAllByStudyProgramId(searchDefinition, pageDefinition);

    log.info(subjects.getContent().toString());

    log.info(
        "{} subjects for study program with id {} on page {} with page size {} returned",
        subjects.getSize(),
        pagitationRequestQuery.page,
        pagitationRequestQuery.page,
        pagitationRequestQuery.size);

    Page<SubjectDto> subjectDtos =
        subjects.map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectDto);

    return ResponseEntity.ok()
        .cacheControl(CacheControl.maxAge(Duration.ofHours(6)))
        .body(subjectDtos);
  }

  @GetMapping("/{subjectCode}")
  public ResponseEntity<SubjectExtendedDto> getSubjectBySubjectCode(@PathVariable String subjectCode) {
    Subject subject = this.subjectService.findBySubjectCode(subjectCode);

    SubjectExtendedDto subjectDto = SubjectMapper.INSTANCE.toSubjectExtendedDto(subject);

    return ResponseEntity.ok(subjectDto);
  }
}
