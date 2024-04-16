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
@Table(name = "text_answer")
public class TextAnswer {
  @EmbeddedId private TextAnswerId id;

  @NotNull
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  private AnswerType answerType;

  @NotNull
  @Column(name = "answer", nullable = false, length = Integer.MAX_VALUE)
  private String answer;

  @NotNull
  @ColumnDefault("now()")
  @Column(name = "\"timestamp\"", nullable = false)
  private Instant timestamp;
}
