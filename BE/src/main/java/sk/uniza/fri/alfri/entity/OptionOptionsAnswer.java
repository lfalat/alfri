package sk.uniza.fri.alfri.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "option_options_answer")
public class OptionOptionsAnswer {
  @EmbeddedId private OptionOptionsAnswerId id;
}
