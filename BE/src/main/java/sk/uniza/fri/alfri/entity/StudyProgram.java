package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "study_program")
public class StudyProgram implements Serializable {
  @Serial private static final long serialVersionUID = -2661297059492111475L;

  @Id
  @Column(name = "study_program_id", nullable = false)
  private Integer id;

  @Size(max = 100)
  @NotBlank(message = "StudyProgram's name cannot be blank or null!")
  @Column(name = "name", nullable = false, length = 100)
  private String name;
}
