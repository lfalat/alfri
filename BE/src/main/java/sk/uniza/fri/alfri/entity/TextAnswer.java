package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
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

  @NotNull(message = "TextAnswer's answer type cannot be null!")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "answer_type_id", nullable = false)
  @JsonManagedReference
  private AnswerType answerType;

  @NotBlank(message = "TextAnswer's answer cannot be blank or null!")
  @Column(name = "answer", nullable = false, length = Integer.MAX_VALUE)
  private String answer;

  @NotNull(message = "TextAnswer's timestamp cannot be null!")
  @ColumnDefault("now()")
  @Column(name = "\"timestamp\"", nullable = false)
  private Instant timestamp;
}
