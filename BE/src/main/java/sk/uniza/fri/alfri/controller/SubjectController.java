package sk.uniza.fri.alfri.controller;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.common.pagitation.PageDefinition;
import sk.uniza.fri.alfri.common.pagitation.PagitationRequestQuery;
import sk.uniza.fri.alfri.common.pagitation.SearchDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortDefinition;
import sk.uniza.fri.alfri.common.pagitation.SortRequestQuery;
import sk.uniza.fri.alfri.dto.KeywordDTO;
import sk.uniza.fri.alfri.dto.StudentYearCountDTO;
import sk.uniza.fri.alfri.dto.SubjectGradeAverageByYearDTO;
import sk.uniza.fri.alfri.dto.SubjectGradeDto;
import sk.uniza.fri.alfri.dto.SubjectsPredictionsResult;
import sk.uniza.fri.alfri.dto.focus.FocusCategorySumDTO;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.dto.subject.SubjectWithCountDto;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.SubjectGrade;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.mapper.StudyProgramSubjectMapper;
import sk.uniza.fri.alfri.mapper.SubjectGradeMapper;
import sk.uniza.fri.alfri.mapper.SubjectMapper;
import sk.uniza.fri.alfri.service.ISubjectService;
import sk.uniza.fri.alfri.service.implementation.AuthService;

import java.io.IOException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RequestMapping("/api/subject")
@RestController
@PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE'})")
@Slf4j
public class SubjectController {
    private final ModelMapper modelMapper;
    private final ISubjectService subjectService;
    private final AuthService authService;

    public SubjectController(ISubjectService subjectService, ModelMapper modelMapper,
                             AuthService authService) {
        this.subjectService = subjectService;
        this.modelMapper = modelMapper;
        this.authService = authService;
    }

    @GetMapping("/all")
    public ResponseEntity<List<SubjectDto>> findAllSubjects() {
        log.info("Getting all subjects");
        List<Subject> subjects = subjectService.findAll();

        return ResponseEntity
                .ok(subjects.stream().map(element -> modelMapper.map(element, SubjectDto.class)).toList());
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Page<SubjectDto>> findAllSubjectsByStudyProgramId(
            PagitationRequestQuery pagitationRequestQuery) {
        log.info("Getting all subjects on page {} with page size {} with filters {}",
                pagitationRequestQuery.page, pagitationRequestQuery.size, pagitationRequestQuery.search);

        SearchDefinition searchDefinition = new SearchDefinition(pagitationRequestQuery.search);
        SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
        PageDefinition pageDefinition = new PageDefinition(pagitationRequestQuery.page,
                pagitationRequestQuery.size, sortDefinition);

        Page<StudyProgramSubject> subjects =
                subjectService.findAllByStudyProgramId(searchDefinition, pageDefinition);

        log.info(subjects.getContent().toString());

        log.info("{} subjects for study program with id {} on page {} with page size {} returned",
                subjects.getSize(), pagitationRequestQuery.page, pagitationRequestQuery.page,
                pagitationRequestQuery.size);

        Page<SubjectDto> subjectDtos =
                subjects.map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectDto);

        return ResponseEntity.ok().cacheControl(CacheControl.maxAge(Duration.ofHours(6)))
                .body(subjectDtos);
    }

    @GetMapping(path = "/focus-prediction", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Page<SubjectExtendedDto>> getAllSubjectsFromFocusPrediction(
            PagitationRequestQuery pagitationRequestQuery) {
        log.info("Getting focus prediction subjects on page {} with page size {}",
                pagitationRequestQuery.page, pagitationRequestQuery.size);

        User user = authService.getCurrentUser()
                .orElseThrow(() -> new EntityNotFoundException("Cannot extract current user"));

        SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
        PageDefinition pageDefinition = new PageDefinition(pagitationRequestQuery.page,
                pagitationRequestQuery.size, sortDefinition);

        Page<Subject> subjects = this.subjectService.makeSubjectsFocusPrediction(user, pageDefinition);

        Page<SubjectExtendedDto> similarSubjectsDto =
                subjects.map(SubjectMapper.INSTANCE::toCustomSubjectExtendedDto);

        return ResponseEntity.ok(similarSubjectsDto);
    }

    @GetMapping(path = "/withFocus", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Page<SubjectExtendedDto>> findAllSubjectsWithFocusByStudyProgramId(
            PagitationRequestQuery pagitationRequestQuery) {
        log.info("Getting all subjects with focus on page {} with page size {} with filters {}",
                pagitationRequestQuery.page, pagitationRequestQuery.size, pagitationRequestQuery.search);

        SearchDefinition searchDefinition = new SearchDefinition(pagitationRequestQuery.search);
        SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
        PageDefinition pageDefinition = new PageDefinition(pagitationRequestQuery.page,
                pagitationRequestQuery.size, sortDefinition);

        Page<StudyProgramSubject> subjects =
                subjectService.findAllByStudyProgramId(searchDefinition, pageDefinition);

        log.info(subjects.getContent().toString());

        log.info(
                "{} subjects with focus for study program with id {} on page {} with page size {} returned",
                subjects.getSize(), pagitationRequestQuery.page, pagitationRequestQuery.page,
                pagitationRequestQuery.size);

        Page<SubjectExtendedDto> subjectDtos =
                subjects.map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectExtendedDto);

        return ResponseEntity.ok().cacheControl(CacheControl.maxAge(Duration.ofHours(6)))
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
            @RequestBody @Valid List<SubjectDto> subjects) {
        log.info("Getting similar subjects for {} subjects", subjects.size());

        List<Subject> subjectList =
                subjects.stream().map(SubjectMapper.INSTANCE::toEntity).toList();

        List<StudyProgramSubject> similarSubjects;
        try {
            similarSubjects = subjectService.getSimilarSubjects(subjectList);
        } catch (IOException e) {
            return ResponseEntity.badRequest().build();
        }

        List<SubjectDto> similarSubjectsDto = similarSubjects.stream()
                .map(StudyProgramSubjectMapper.INSTANCE::studyProgramSubjectToSubjectDto).toList();

        log.info("Returning {} similar subjects", similarSubjectsDto.size());

        return ResponseEntity.ok().body(similarSubjectsDto);
    }

    @GetMapping("/with-grades")
    public ResponseEntity<Page<SubjectGradeDto>> getSubjectsWithGrades(
            PagitationRequestQuery pagitationRequestQuery) {
        log.info("Getting subjects with grades on page {} with page size {}",
                pagitationRequestQuery.page, pagitationRequestQuery.size);

        SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
        PageDefinition pageDefinition = new PageDefinition(pagitationRequestQuery.page,
                pagitationRequestQuery.size, sortDefinition);

        Page<SubjectGrade> subjects = subjectService.getSubjectsWithGrades(pageDefinition);

        Page<SubjectGradeDto> subjectGradeDtos =
                subjects.map(SubjectGradeMapper.INSTANCE::toDto);

        log.info("{} subjects with grades returned on page {} with page size {}",
                subjects.getSize(), pagitationRequestQuery.page, pagitationRequestQuery.size);

        return ResponseEntity.ok().body(subjectGradeDtos);
    }

    @GetMapping("/makePredictions")
    public ResponseEntity<List<SubjectsPredictionsResult>> makeMarkAndPassingChangePredictionsByStudentYear() {
        User currentUser = authService.getCurrentUser()
                .orElseThrow(() -> new EntityNotFoundException("User's email was not found!"));

        String currentUserEmail = currentUser.getEmail();

        log.info("Making prediction by student year for user with email {}", currentUserEmail);

        List<String> marksList = subjectService.makePassingMarkPrediction(currentUserEmail);
        List<String> chanceList = subjectService.makePassingChancePrediction(currentUserEmail);

        Map<String, String> marksMap = marksList.stream().map(s -> s.split(":", 2))
                .collect(Collectors.toMap(arr -> arr[0].trim(), arr -> arr[1].trim()));

        Map<String, Double> chanceMap = chanceList.stream().map(s -> s.split(":", 2))
                .collect(Collectors.toMap(arr -> arr[0].trim(), arr -> Double.valueOf(arr[1].trim())));

        List<SubjectsPredictionsResult> result = new ArrayList<>();
        for (Map.Entry<String, String> entry : marksMap.entrySet()) {
            String subjectName = entry.getKey();
            String mark = entry.getValue();
            Double passingChance = chanceMap.getOrDefault(subjectName, 0.0);

            SubjectsPredictionsResult prediction = new SubjectsPredictionsResult();
            prediction.setSubjectName(subjectName);
            prediction.setMark(mark);
            prediction.setPassingProbability(passingChance);

            result.add(prediction);
        }

        return ResponseEntity.ok(result);
    }

    @GetMapping("/mostPopularElectives")
    public ResponseEntity<Page<SubjectDto>> getMostPopularElectiveSubjects(
            PagitationRequestQuery pagitationRequestQuery) {
        log.info("Getting most popular elective subjects on page {} with page size {}",
                pagitationRequestQuery.page, pagitationRequestQuery.size);

        SortDefinition sortDefinition = SortRequestQuery.from(pagitationRequestQuery.sort);
        PageDefinition pageDefinition = new PageDefinition(pagitationRequestQuery.page,
                pagitationRequestQuery.size, sortDefinition);

        Page<SubjectWithCountDto> subjects = subjectService.getMostPopularElectiveSubjects(pageDefinition);

        Page<SubjectDto> subjectDtos =
                subjects.map(StudyProgramSubjectMapper.INSTANCE::subjectWithCountDtoToSubjectDto);

        return ResponseEntity.ok().cacheControl(CacheControl.maxAge(Duration.ofHours(6)))
                .body(subjectDtos);
    }

    @GetMapping("/{subjectId}/grade-averages-by-year")
    public ResponseEntity<List<SubjectGradeAverageByYearDTO>> getSubjectGradeAveragesByYear(
            @PathVariable @Positive Integer subjectId) {
        log.info("Getting grade averages for subject with id {} grouped by year", subjectId);

        List<SubjectGradeAverageByYearDTO> gradeAverages =
                subjectService.getSubjectGradeAveragesByYear(subjectId);

        log.info("Returning {} year records for subject with id {}", gradeAverages.size(), subjectId);

        return ResponseEntity.ok().body(gradeAverages);
    }
}
