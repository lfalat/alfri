package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.util.Objects;

@Getter
@Setter
@Embeddable
public class StudyProgramSubjectId {

    @NotNull(message = "StudyProgramSubjetId's subject id cannot be null!")
    @Column(name = "subject_id", nullable = false)
    private Integer subjectId;

    @NotNull(message = "StudyProgramSubjetId's study program id id cannot be null!")
    @Column(name = "study_program_id", nullable = false)
    private Integer studyProgramId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "subject_id", nullable = false, insertable = false, updatable = false)
    private Subject subject;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "study_program_id", nullable = false, insertable = false, updatable = false)
    private StudyProgram studyProgram;

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o))
            return false;
        StudyProgramSubjectId entity = (StudyProgramSubjectId) o;
        return Objects.equals(this.studyProgramId, entity.studyProgramId)
                && Objects.equals(this.subjectId, entity.subjectId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(studyProgramId, subjectId);
    }
}
