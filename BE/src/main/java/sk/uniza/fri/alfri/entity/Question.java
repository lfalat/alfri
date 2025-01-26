package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "question")
public class Question {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('question_question_id_seq')")
  @Column(name = "question_id", nullable = false)
  private Integer id;

  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "section_id", nullable = false)
  private QuestionnaireSection questionnaireSection;

  @NotNull(message = "Question's answer type cannot be null!")
  @Column(name = "answer_type_id", nullable = false)
  private Integer answerType;

  @NotNull(message = "Question's position in questionnaire cannot be null!")
  @Positive(message = "Question's position in questionnaire cannot be negative number or zero!")
  @Column(name = "position_in_questionnaire", nullable = false)
  private Integer positionInQuestionnaire;

  @NotBlank(message = "Question's content cannot be blank or null!")
  @Column(name = "question_title", nullable = false, length = Integer.MAX_VALUE)
  private String questionTitle;

  @NotBlank(message = "Question's identifier cannot be blank or null!")
  @Column(name = "question_identifier", nullable = false, length = Integer.MAX_VALUE)
  private String questionIdentifier;


  @NotNull(message = "Question's optional cannot be null!")
  @Column(name = "optional", nullable = false)
  private Boolean optional = false;

  @OneToMany(mappedBy = "question", fetch = FetchType.LAZY, cascade = CascadeType.ALL,
      orphanRemoval = true)
  @JsonBackReference
  private List<QuestionOption> options = new ArrayList<>();

  @OneToMany(mappedBy = "answerQuestion", fetch = FetchType.LAZY, cascade = CascadeType.ALL,
      orphanRemoval = true)
  @JsonBackReference
  private List<Answer> answers = new ArrayList<>();
}
