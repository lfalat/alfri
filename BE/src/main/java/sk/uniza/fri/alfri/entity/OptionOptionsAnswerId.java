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
public class OptionOptionsAnswerId implements Serializable {
  @Serial private static final long serialVersionUID = 162428352418226290L;

  @NotNull(message = "OptionOptionsAnswerId options_answer_id cannot be null!")
  @Column(name = "options_answer_id", nullable = false)
  private Integer optionsAnswerId;

  @NotNull(message = "OptionOptionsAnswerId option_id cannot be null!")
  @Column(name = "option_id", nullable = false)
  private Integer optionId;

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
    OptionOptionsAnswerId entity = (OptionOptionsAnswerId) o;
    return Objects.equals(this.optionsAnswerId, entity.optionsAnswerId)
        && Objects.equals(this.optionId, entity.optionId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(optionsAnswerId, optionId);
  }
}
