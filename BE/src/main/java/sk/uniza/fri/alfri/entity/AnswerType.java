package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;
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
  @JsonBackReference
  private List<NumericAnswer> numericAnswers = new ArrayList<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  @JsonBackReference
  private List<OptionsAnswer> optionsAnswers = new ArrayList<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  @JsonBackReference
  private List<Question> questions = new ArrayList<>();

  @OneToMany(mappedBy = "answerType", fetch = FetchType.LAZY)
  @JsonBackReference
  private List<TextAnswer> textAnswers = new ArrayList<>();
}
