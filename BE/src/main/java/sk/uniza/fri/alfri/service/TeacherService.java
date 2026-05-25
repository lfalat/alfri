package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.Teacher;

import java.util.List;

public interface TeacherService {
    List<Subject> getSubjectsOfTeacherById(Integer userId);

    Teacher findByUserId(Integer userId);

    Teacher createTeacher(Integer userId);

    void deleteTeacher(Integer userId);

    Teacher changeDepartment(Integer departmentId, Integer userId);
}
