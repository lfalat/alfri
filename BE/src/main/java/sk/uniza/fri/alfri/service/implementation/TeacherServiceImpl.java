package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.Teacher;
import sk.uniza.fri.alfri.projection.SubjectIdProjection;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.repository.TeacherRepository;
import sk.uniza.fri.alfri.repository.TeacherSubjectRepository;
import sk.uniza.fri.alfri.service.TeacherService;

import java.util.List;

/** Created by petos on 11/22/24. */
@Service
public class TeacherServiceImpl implements TeacherService {
  private final TeacherRepository teacherRepository;
  private final TeacherSubjectRepository teacherSubjectRepository;
  private final SubjectRepository subjectRepository;

  public TeacherServiceImpl(TeacherRepository teacherRepository,
      TeacherSubjectRepository teacherSubjectRepository, SubjectRepository subjectRepository) {
    this.teacherRepository = teacherRepository;
    this.teacherSubjectRepository = teacherSubjectRepository;
    this.subjectRepository = subjectRepository;
  }

  @Override
  public List<Subject> getSubjectsOfTeacherById(Integer userId) {
    Teacher teacher =
        teacherRepository.findByUserId(userId).orElseThrow(() -> new EntityNotFoundException(
            String.format("Teacher with user id %d was not found!", userId)));

    List<SubjectIdProjection> projections =
        teacherSubjectRepository.findIdByIdTeacherId(teacher.getId());
    List<Integer> teacherSubjectIds =
        projections.stream().map(SubjectIdProjection::getSubjectId).toList();

    return subjectRepository.findAllById(teacherSubjectIds);
  }
}
