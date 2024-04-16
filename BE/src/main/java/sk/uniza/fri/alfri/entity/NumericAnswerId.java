package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

@Getter
@Setter
@Embeddable
public class NumericAnswerId implements Serializable {
  @Serial private static final long serialVersionUID = -4189442188205556803L;

  @NotNull
  @Column(name = "question_id", nullable = false)
  private Integer questionId;

  @NotNull
  @Column(name = "questionnaire_id", nullable = false)
  private Integer questionnaireId;

  @NotNull
  @Column(name = "user_id", nullable = false)
  private Integer userId;

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
    NumericAnswerId entity = (NumericAnswerId) o;
    return Objects.equals(this.questionId, entity.questionId)
        && Objects.equals(this.questionnaireId, entity.questionnaireId)
        && Objects.equals(this.userId, entity.userId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(questionId, questionnaireId, userId);
  }
}
