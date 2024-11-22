package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.Subject;

import java.util.List;

public interface TeacherService {
  List<Subject> getSubjectsOfTeacherById(Integer userId);
}
