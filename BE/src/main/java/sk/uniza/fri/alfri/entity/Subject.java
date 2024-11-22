package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "subject")
public class Subject implements Serializable {
  @Serial
  private static final long serialVersionUID = 9150108708633901692L;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('subject_subject_id_seq'")
  @Column(name = "subject_id", nullable = false)
  private Integer id;

  @Size(max = 100)
  @NotBlank(message = "Subject's name cannot be blank or null!")
  @Column(name = "name", nullable = false, length = 100)
  private String name;

  @Size(max = 50)
  @NotBlank(message = "Subject's code cannot be blank or null!")
  @Column(name = "code", nullable = false, length = 50)
  private String code;

  @NotBlank(message = "Subject's abbreviation cannot be blank or null!")
  @Column(name = "abbreviation", nullable = false, length = Integer.MAX_VALUE)
  private String abbreviation;

  @OneToOne(mappedBy = "subject")
  @JsonBackReference
  private Focus focus;
}
