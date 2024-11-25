package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "student_subject")
public class StudentSubject {
  @EmbeddedId
  private StudentSubjectId id;

  @Column(name = "year", nullable = false)
  @NotNull(message = "StudentSubject's year cannot be null!")
  @Positive(message = "StudentSubject's year must be positive!")
  private Integer year;

  @Size(max = 2)
  @Column(name = "mark", length = 2)
  private String mark;
}
