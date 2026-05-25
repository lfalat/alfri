package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Formula;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Entity
@Table(name = "student_subject")
@IdClass(StudentSubject.StudentSubjectPK.class)
public class StudentSubject {

    @Id
    @NotNull(message = "StudentSubject's student id cannot be null!")
    @Column(name = "student_id", nullable = false)
    private Integer studentId;

    @Id
    @NotNull(message = "StudentSubject's subject id cannot be null!")
    @Column(name = "subject_id", nullable = false)
    private Integer subjectId;

    @Id
    @NotNull(message = "StudentSubject's year cannot be null!")
    @Positive(message = "StudentSubject's year must be positive!")
    @Column(name = "year", nullable = false)
    private Integer year;

    @NotNull(message = "StudentSubject's calendar year cannot be null!")
    @Positive(message = "StudentSubject's calendar year must be positive!")
    @Column(name = "calendar_year", nullable = false)
    private Integer calendarYear;

    @Size(max = 2)
    @Column(name = "mark", length = 2)
    private String mark;

    @Formula("convert_mark_to_grade(mark)")
    private Double convertedMark;

    public static class StudentSubjectPK implements Serializable {
        private Integer studentId;
        private Integer subjectId;
        private Integer year;

        public StudentSubjectPK() {
        }

        public StudentSubjectPK(Integer studentId, Integer subjectId, Integer year) {
            this.studentId = studentId;
            this.subjectId = subjectId;
            this.year = year;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o)
                return true;
            if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o))
                return false;
            StudentSubjectPK that = (StudentSubjectPK) o;
            return Objects.equals(this.studentId, that.studentId)
                    && Objects.equals(this.subjectId, that.subjectId)
                    && Objects.equals(this.year, that.year);
        }

        @Override
        public int hashCode() {
            return Objects.hash(studentId, subjectId, year);
        }
    }

}
