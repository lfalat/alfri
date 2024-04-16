package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "answer_type")
public class AnswerType {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('answer_type_answer_type_id_seq'")
  @Column(name = "answer_type_id", nullable = false)
  private Integer id;

  @Size(max = 50)
  @NotBlank(message = "Answer type name cannot be blank or empty!")
  @Column(name = "name", nullable = false, length = 50)
  private String name;

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  private Set<NumericAnswer> numericAnswers = new LinkedHashSet<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  private Set<OptionsAnswer> optionsAnswers = new LinkedHashSet<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  private Set<Question> questions = new LinkedHashSet<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  private Set<TextAnswer> textAnswers = new LinkedHashSet<>();
}
