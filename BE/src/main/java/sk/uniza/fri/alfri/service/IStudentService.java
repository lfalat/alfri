package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.entity.User;

public interface IStudentService {
  StudyProgram getUsersStudyProgram(String userEmail);

  StudyProgram getUsersStudyProgram(User user);
}
