package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.StudyProgramDto;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.mapper.StudyProgramMapper;
import sk.uniza.fri.alfri.service.IAuthService;
import sk.uniza.fri.alfri.service.IStudentService;

import java.io.IOException;

@RequestMapping("/api/student")
@RestController
@PreAuthorize("hasAnyRole({'ROLE_STUDENT', 'ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE'})")
@Slf4j
public class StudentController {
    private final IAuthService authService;
    private final IStudentService studentService;
    private final StudyProgramMapper studyProgramMapper;

    public StudentController(IAuthService authService, IStudentService studentService,
                             StudyProgramMapper studyProgramMapper) {
        this.authService = authService;
        this.studentService = studentService;
        this.studyProgramMapper = studyProgramMapper;
    }

    @GetMapping(value = "/current/studyProgram", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<StudyProgramDto> getCurrentStudentsStudyProgram() {
        log.info("Getting study program started");
        String userEmail = authService.getCurrentUserEmail()
                .orElseThrow(() -> new UsernameNotFoundException("Cannot retrieve current user!"));
        log.info("Getting study program of current user with email {}", userEmail);

        StudyProgram studyProgram = studentService.getUsersStudyProgram(userEmail);

        StudyProgramDto studyProgramDto = studyProgramMapper.toDto(studyProgram);

        log.info("Returning study program {} for user with email {}", studyProgram, userEmail);

        return ResponseEntity.ok(studyProgramDto);
    }

    @GetMapping(value = "/prediction")
    public void makePrediction() throws IOException {
        log.info("Make prediction started");
        this.studentService.makePrediction();
    }
}
