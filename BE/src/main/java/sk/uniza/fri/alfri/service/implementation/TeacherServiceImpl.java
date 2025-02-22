package sk.uniza.fri.alfri.service.implementation;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import sk.uniza.fri.alfri.entity.Department;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.Teacher;
import sk.uniza.fri.alfri.entity.User;
import sk.uniza.fri.alfri.projection.SubjectIdProjection;
import sk.uniza.fri.alfri.repository.DepartmentRepository;
import sk.uniza.fri.alfri.repository.SubjectRepository;
import sk.uniza.fri.alfri.repository.TeacherRepository;
import sk.uniza.fri.alfri.repository.TeacherSubjectRepository;
import sk.uniza.fri.alfri.service.TeacherService;
import sk.uniza.fri.alfri.service.UserService;

import java.util.List;
import java.util.Optional;

/**
 * Created by petos on 11/22/24.
 */
@Service
public class TeacherServiceImpl implements TeacherService {
    private final TeacherRepository teacherRepository;
    private final TeacherSubjectRepository teacherSubjectRepository;
    private final SubjectRepository subjectRepository;
    private final UserService userService;
    private final DepartmentRepository departmentRepository;

    public TeacherServiceImpl(TeacherRepository teacherRepository,
                              TeacherSubjectRepository teacherSubjectRepository, SubjectRepository subjectRepository,
                              UserService userService, DepartmentRepository departmentRepository) {
        this.teacherRepository = teacherRepository;
        this.teacherSubjectRepository = teacherSubjectRepository;
        this.subjectRepository = subjectRepository;
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @Override
    public List<Subject> getSubjectsOfTeacherById(Integer userId) {
        Teacher teacher = this.findByUserId(userId);

        List<SubjectIdProjection> projections =
                teacherSubjectRepository.findIdByIdTeacherId(teacher.getId());
        List<Integer> teacherSubjectIds =
                projections.stream().map(SubjectIdProjection::getSubjectId).toList();

        return subjectRepository.findAllById(teacherSubjectIds);
    }

    @Override
    public Teacher findByUserId(Integer userId) {
        return teacherRepository.findByUserId(userId).orElseThrow(() -> new EntityNotFoundException(
                String.format("Teacher with user id %d was not found!", userId)));
    }

    @Override
    public Teacher createTeacher(Integer userId) {
        Optional<Teacher> existingTeacher = teacherRepository.findByUserId(userId);
        if (existingTeacher.isPresent()) {
            return existingTeacher.get();
        }

        User user = userService.getUser(userId);

        Teacher newTeacher = Teacher.builder().user(user).build();

        return teacherRepository.save(newTeacher);
    }

    @Override
    public void deleteTeacher(Integer userId) {
        Optional<Teacher> existingTeacher = teacherRepository.findByUserId(userId);

        if (existingTeacher.isEmpty()) {
            return;
        }

        teacherRepository.delete(existingTeacher.get());
    }

    @Override
    public Teacher changeDepartment(Integer departmentId, Integer userId) {
        Teacher teacher = findByUserId(userId);

        if (departmentId == null) {
            teacher.setDepartment(null);
            return teacherRepository.save(teacher);
        }

        Department department =
                departmentRepository.findById(departmentId).orElseThrow(() -> new EntityNotFoundException(
                        String.format("Department with id %d was not found", departmentId)));

        teacher.setDepartment(department);
        return teacherRepository.save(teacher);
    }
}
