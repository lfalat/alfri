package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.StudyProgramDto;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.mapper.StudyProgramMapper;
import sk.uniza.fri.alfri.service.IStudyProgramService;

import java.util.List;

@RequestMapping("/api/studyProgram")
@RestController
@PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE'})")
@Slf4j
public class StudyProgramController {
    private final StudyProgramMapper studyProgramMapper;
    private final IStudyProgramService studyProgramService;

    public StudyProgramController(IStudyProgramService studyProgramService,
                                  StudyProgramMapper studyProgramMapper) {
        this.studyProgramService = studyProgramService;
        this.studyProgramMapper = studyProgramMapper;
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<StudyProgramDto>> findAll() {
        log.info("Find all study programs requested");
        List<StudyProgram> studyProgramList = studyProgramService.findAll();

        List<StudyProgramDto> studyProgramDtos =
                studyProgramList.stream().map(studyProgramMapper::toDto).toList();

        log.info("Returning {} study programs", studyProgramDtos.size());

        return ResponseEntity.ok().body(studyProgramDtos);
    }
}
