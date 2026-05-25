package sk.uniza.fri.alfri.projection;

import sk.uniza.fri.alfri.entity.StudyProgramSubject;

public interface StudyProgramSubjectWithCountProjection {
    StudyProgramSubject getStudyProgramSubject();
    Long getStudentCount();
}

