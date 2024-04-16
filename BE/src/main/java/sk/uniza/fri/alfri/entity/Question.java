package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.util.LinkedHashSet;
import java.util.Set;
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
  @ColumnDefault("nextval('question_question_id_seq'")
  @Column(name = "question_id", nullable = false)
  private Integer id;

  @NotNull
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "questionnaire_id", nullable = false)
  private Questionnaire questionnaire;

  @NotNull
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  private AnswerType answerType;

  @NotNull
  @Column(name = "position_in_questionnaire", nullable = false)
  private Integer positionInQuestionnaire;

  @NotNull
  @Column(name = "content", nullable = false, length = Integer.MAX_VALUE)
  private String content;

  @NotNull
  @Column(name = "optional", nullable = false)
  private Boolean optional = false;

  @OneToMany(mappedBy = "question", fetch = FetchType.LAZY)
  private Set<Option> options = new LinkedHashSet<>();
}
