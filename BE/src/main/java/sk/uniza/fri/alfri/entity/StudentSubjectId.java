package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

@Getter
@Setter
@Embeddable
public class StudentSubjectId implements Serializable {
  @Serial private static final long serialVersionUID = -5039088440635804271L;

  @NotNull
  @Column(name = "student_id", nullable = false)
  private Integer studentId;

  @NotNull
  @Column(name = "subject_id", nullable = false)
  private Integer subjectId;

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
    StudentSubjectId entity = (StudentSubjectId) o;
    return Objects.equals(this.studentId, entity.studentId)
        && Objects.equals(this.subjectId, entity.subjectId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(studentId, subjectId);
  }
}
