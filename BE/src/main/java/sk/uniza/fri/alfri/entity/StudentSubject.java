package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

@Getter
@Setter
@Entity
@Table(name = "student_subject")
public class StudentSubject {
  @EmbeddedId private StudentSubjectId id;

  @NotNull(message = "StudentSubject's year cannot be null!")
  @Column(name = "year", nullable = false)
  @DateTimeFormat(style = "yyyy-mm-dd")
  private LocalDate year;

  @Size(max = 2)
  @Column(name = "mark", length = 2)
  private String mark;
}