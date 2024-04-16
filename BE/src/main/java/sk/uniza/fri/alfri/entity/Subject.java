package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "subject")
public class Subject {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('subject_subject_id_seq'")
  @Column(name = "subject_id", nullable = false)
  private Integer id;

  @Size(max = 100)
  @NotNull
  @Column(name = "name", nullable = false, length = 100)
  private String name;

  @Size(max = 50)
  @NotNull
  @Column(name = "code", nullable = false, length = 50)
  private String code;

  @NotNull
  @Column(name = "description", nullable = false, length = Integer.MAX_VALUE)
  private String description;

  @OneToOne(mappedBy = "subject")
  private Focus focus;
}
