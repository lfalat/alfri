package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
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
public class StudyProgramSubjectId implements Serializable {
  @Serial private static final long serialVersionUID = 8957191210572894102L;

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
    if (this == o) return true;
    if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
    StudyProgramSubjectId entity = (StudyProgramSubjectId) o;
    return Objects.equals(this.studyProgramId, entity.studyProgramId)
        && Objects.equals(this.subjectId, entity.subjectId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(studyProgramId, subjectId);
  }
}
