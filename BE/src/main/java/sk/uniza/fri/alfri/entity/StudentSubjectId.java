package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.util.Objects;

@Getter
@Setter
@Embeddable
public class StudentSubjectId {

    @NotNull(message = "StudentSubjectId's student id cannot be null!")
    @Column(name = "student_id", nullable = false)
    private Integer studentId;

    @NotNull(message = "StudentSubjectId's subject id cannot be null!")
    @Column(name = "subject_id", nullable = false)
    private Integer subjectId;

    @Column(name = "year", nullable = false)
    @NotNull(message = "StudentSubject's year cannot be null!")
    @Positive(message = "StudentSubject's year must be positive!")
    private Integer year;

    public StudentSubjectId(int i, int i1, int number) {
        this.studentId = i;
        this.subjectId = i1;
        this.year = number;
    }

    public StudentSubjectId() {

    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o))
            return false;
        StudentSubjectId entity = (StudentSubjectId) o;
        return Objects.equals(this.studentId, entity.studentId)
                && Objects.equals(this.subjectId, entity.subjectId)
                && Objects.equals(this.year, entity.year);
    }

    @Override
    public int hashCode() {
        return Objects.hash(studentId, subjectId);
    }
}
