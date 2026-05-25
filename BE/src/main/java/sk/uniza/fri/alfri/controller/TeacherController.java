package sk.uniza.fri.alfri.controller;

import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.infrastructure.PythonMlClient;
import sk.uniza.fri.alfri.dto.TeacherDto;
import sk.uniza.fri.alfri.dto.subject.SubjectDto;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.service.TeacherService;

import java.util.List;

/**
 * Created by petos on 11/22/24.
 */

@RestController
@Slf4j
@PreAuthorize("hasAnyRole('ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE')")
@RequestMapping("/api/teacher")
public class TeacherController {
    private final ModelMapper modelMapper;
    private final TeacherService teacherService;
  private final PythonMlClient pythonMlClient;

    public TeacherController(TeacherService teacherService, ModelMapper modelMapper, PythonMlClient pythonMlClient) {
    this.teacherService = teacherService;
    this.modelMapper = modelMapper;
      this.pythonMlClient = pythonMlClient;
  }

    @GetMapping("/{userId}")
    public ResponseEntity<TeacherDto> findTeacherByUserId(@PathVariable Integer userId) {
        log.info("Getting teacher with user id {}", userId);

        TeacherDto teacherDto = modelMapper.map(teacherService.findByUserId(userId), TeacherDto.class);

        return ResponseEntity.ok(teacherDto);
    }

    @GetMapping("/{userId}/subjects")
    public ResponseEntity<List<SubjectDto>> getTeacherSubjects(@PathVariable Integer userId) {
        log.info("Getting all subjects of teacher with userId id {}", userId);

        List<Subject> subjects = teacherService.getSubjectsOfTeacherById(userId);

        List<SubjectDto> subjectDtos =
                subjects.stream().map(element -> modelMapper.map(element, SubjectDto.class)).toList();

        log.info("{} subjects of teacher with userid {} returned", subjectDtos.size(), userId);

        return ResponseEntity.ok(subjectDtos);
    }

  @GetMapping("/test")
    public ResponseEntity<String> testEndpoint() {
        return pythonMlClient.test();
    }
}
