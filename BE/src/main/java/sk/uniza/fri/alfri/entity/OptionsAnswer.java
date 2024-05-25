package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "options_answer")
public class OptionsAnswer {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('options_answer_seq'::regclass)")
  @Column(name = "options_answer_id", nullable = false)
  private Integer optionsAnswerId;

  @NotNull(message = "OptionsAnswer's questionnaireId cannot be null!")
  @Column(name = "questionnaire_id", nullable = false)
  private Integer questionnaireId;

  @NotNull(message = "OptionsAnswer's questionId cannot be null!")
  @Column(name = "question_id", nullable = false)
  private Integer questionId;

  @NotNull(message = "OptionsAnswer's userId cannot be null!")
  @Column(name = "user_id", nullable = false)
  private Integer userId;

  @NotNull(message = "OptionsAnswer's answerType cannot be null!")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  @JsonManagedReference
  private AnswerType answerType;

  @NotNull(message = "OptionsAnswer's timestamp cannot be null!")
  @ColumnDefault("now()")
  @Column(name = "\"timestamp\"", nullable = false)
  private Instant timestamp;
}
