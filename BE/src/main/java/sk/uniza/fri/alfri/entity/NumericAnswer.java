package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.Instant;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "numeric_answer")
public class NumericAnswer {
  @EmbeddedId private NumericAnswerId id;

  @NotNull(message = "Numeric's answer answer type cannot be null!")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  private AnswerType answerType;

  @NotNull(message = "Numeric's answer answer cannot be null!")
  @Column(name = "answer", nullable = false)
  private BigDecimal answer;

  @NotNull(message = "Numeric's answer timestamp cannot be null!")
  @ColumnDefault("now()")
  @Column(name = "\"timestamp\"", nullable = false)
  private Instant timestamp;
}
