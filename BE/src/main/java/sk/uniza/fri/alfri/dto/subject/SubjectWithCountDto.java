package sk.uniza.fri.alfri.dto.subject;

import lombok.Data;
import lombok.NoArgsConstructor;
import sk.uniza.fri.alfri.entity.StudyProgramSubject;

import java.io.Serializable;

@Data
@NoArgsConstructor
public class SubjectWithCountDto implements Serializable {
    private StudyProgramSubject studyProgramSubject;
    private Long studentCount;

    public SubjectWithCountDto(StudyProgramSubject studyProgramSubject, Long studentCount) {
        this.studyProgramSubject = studyProgramSubject;
        this.studentCount = studentCount;
    }
}

