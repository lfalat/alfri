package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "questionnaire")
public class Questionnaire {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('questionnaire_questionnaire_id_seq'")
  @Column(name = "questionnaire_id", nullable = false)
  private Integer id;

  @Size(max = 100)
  @NotNull
  @Column(name = "title", nullable = false, length = 100)
  private String title;

  @NotNull
  @Column(name = "description", nullable = false, length = Integer.MAX_VALUE)
  private String description;

  @NotNull
  @ColumnDefault("now()")
  @Column(name = "date_of_creation", nullable = false)
  private Instant dateOfCreation;

  @OneToMany(mappedBy = "questionnaire", fetch = FetchType.LAZY)
  private Set<Question> questions = new LinkedHashSet<>();
}
