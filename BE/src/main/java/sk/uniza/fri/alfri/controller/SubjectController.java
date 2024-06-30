package sk.uniza.fri.alfri.controller;

import jakarta.validation.Valid;
import java.io.IOException;
import java.time.Duration;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PagitationRequestQuery;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortRequestQuery;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.StudyProgramSubjectMapper;
import sk.uniza.fri.alfri.mapper.SubjectMapper;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.service.UserService;
import sk.uniza.fri.alfri.service.implementation.JwtService;

@RequestMapping("/api/subject")
@RestController
@Slf4j
public class SubjectController {
  private final ISubjectService subjectService;
  private final JwtService jwtService;
  private final UserService userService;

  public SubjectController(ISubjectService subjectService, JwtService jwtService, UserService userService) {
    this.subjectService = subjectService;
      this.jwtService = jwtService;
      this.userService = userService;
  }

  @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
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
        new PageDefinition(
            pagitationRequestQuery.page, pagitationRequestQuery.size, sortDefinition);

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

  @GetMapping(path = "/focus-prediction", produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<List<SubjectExtendedDto>> getAllSubjectsFromFocusPrediction(@RequestHeader(value = "Authorization") String token) {

    String parsedToken = token.replace("Bearer ", "");
    String username = jwtService.extractUsername(parsedToken);
    User user = userService.getUser(username);

    List<Subject> subjects = this.subjectService.makeSubjectsFocusPrediction(user);

    List<SubjectExtendedDto> similarSubjectsDto =
            subjects.stream()
                    .map(SubjectMapper.INSTANCE::toSubjectExtendedDto).toList();

    return ResponseEntity.ok(similarSubjectsDto);
  }

  @GetMapping(path = "/withFocus", produces = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<Page<SubjectExtendedDto>> findAllSubjectsWithFocusByStudyProgramId(
      PagitationRequestQuery pagitationRequestQuery) {
    log.info(
        "Getting all subjects with focus on page {} with page size {} with filters {}",
        pagitationRequestQuery.page,
        pagitationRequestQuery.size,
        pagitationRequestQuery.search);

    SearchDefinition searchDefinition = new SearchDefinition(pagitationRequestQuery.search);
    SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
    PageDefinition pageDefinition =
        new PageDefinition(
            pagitationRequestQuery.page, pagitationRequestQuery.size, sortDefinition);

    Page<StudyProgramSubject> subjects =
        subjectService.findAllByStudyProgramId(searchDefinition, pageDefinition);

    log.info(subjects.getContent().toString());

    log.info(
        "{} subjects with focus for study program with id {} on page {} with page size {} returned",
        subjects.getSize(),
        pagitationRequestQuery.page,
        pagitationRequestQuery.page,
        pagitationRequestQuery.size);

    Page<SubjectExtendedDto> subjectDtos =
        subjects.map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectExtendedDto);

    return ResponseEntity.ok()
        .cacheControl(CacheControl.maxAge(Duration.ofHours(6)))
        .body(subjectDtos);
  }

  @GetMapping("/{subjectCode}")
  public ResponseEntity<SubjectExtendedDto> getSubjectBySubjectCode(
      @PathVariable String subjectCode) {
    log.info("Getting subject by cubject code {}", subjectCode);
    Subject subject = this.subjectService.findBySubjectCode(subjectCode);

    SubjectExtendedDto subjectDto = SubjectMapper.INSTANCE.toSubjectExtendedDto(subject);

    return ResponseEntity.ok(subjectDto);
  }

  @PostMapping("/similarSubjects")
  public ResponseEntity<List<SubjectDto>> getSimilarSubject(
      @RequestBody @Valid List<SubjectExtendedDto> subjects) {
    log.info("Getting similar subjects for {} subjects", subjects.size());

    List<Subject> subjectList =
        subjects.stream().map(SubjectMapper.INSTANCE::fromSubjectExtendedDtotoEntity).toList();

    List<StudyProgramSubject> similarSubjects = null;
    try {
      similarSubjects = subjectService.getSimilarSubjects(subjectList);
    } catch (IOException e) {
      return ResponseEntity.badRequest().build();
    }

    List<SubjectDto> similarSubjectsDto =
        similarSubjects.stream()
            .map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectDto)
            .toList();

    log.info("Returning {} similar subjects", similarSubjectsDto.size());

    return ResponseEntity.ok().body(similarSubjectsDto);
  }
}
