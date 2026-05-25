package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.Student;
import sk.uniza.fri.alfri.entity.StudyProgram;
import sk.uniza.fri.alfri.entity.User;

import java.io.IOException;

public interface IStudentService {
    StudyProgram getUsersStudyProgram(String userEmail);

    StudyProgram getUsersStudyProgram(User user);

    void makePrediction() throws IOException;

    Student getStudentByUserEmail(String userEmail);
}
