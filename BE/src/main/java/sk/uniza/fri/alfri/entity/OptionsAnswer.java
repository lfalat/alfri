package sk.uniza.fri.alfri.entity;

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
  @EmbeddedId private OptionsAnswerId id;

  @NotNull(message = "OptionsAnswer's answerType cannot be null!")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  private AnswerType answerType;

  @NotNull(message = "OptionsAnswer's timestamp cannot be null!")
  @ColumnDefault("now()")
  @Column(name = "\"timestamp\"", nullable = false)
  private Instant timestamp;
}
