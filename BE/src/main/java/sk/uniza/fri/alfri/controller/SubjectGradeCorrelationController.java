package sk.uniza.fri.alfri.controller;

import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.query.sqm.ComparisonOperator;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.SubjectGradeCorrelationDto;
import sk.uniza.fri.alfri.entity.SubjectGradeCorrelation;
import sk.uniza.fri.alfri.mapper.SubjectGradeCorrelationMapper;
import sk.uniza.fri.alfri.service.SubjectGradeCorrelationService;

@RestController
@RequestMapping("/api/subject-grade-correlation-controller")
@Slf4j
public class SubjectGradeCorrelationController {
  private final SubjectGradeCorrelationMapper subjectGradeCorrelationMapper;
  private final SubjectGradeCorrelationService subjectGradeCorrelationService;

  public SubjectGradeCorrelationController(
      SubjectGradeCorrelationService subjectGradeCorrelationService,
      SubjectGradeCorrelationMapper subjectGradeCorrelationMapper) {
    this.subjectGradeCorrelationService = subjectGradeCorrelationService;
    this.subjectGradeCorrelationMapper = subjectGradeCorrelationMapper;
  }

  @GetMapping(path = "/correlation", produces = MediaType.APPLICATION_JSON_VALUE)
  public List<SubjectGradeCorrelationDto> getAllSubjectGradesCorrelations(
      @RequestParam(required = false) Double correlationTreshold,
      @RequestParam(required = false) String operator) {
    log.info("Getting all subject grade correlations");

    List<SubjectGradeCorrelation> subjectGradeCorrelations;

    if (correlationTreshold == null || operator == null) {
      subjectGradeCorrelations = subjectGradeCorrelationService.findAll();
    } else {
      subjectGradeCorrelations =
          subjectGradeCorrelationService.findAllWithCorrelation(correlationTreshold, operator);
    }

    List<SubjectGradeCorrelationDto> subjectGradeCorrelationDtos =
        subjectGradeCorrelations.stream().map(subjectGradeCorrelationMapper::toDto).toList();

    log.info("{} correlations retrieved", subjectGradeCorrelationDtos.size());

    return subjectGradeCorrelationDtos;
  }
}
