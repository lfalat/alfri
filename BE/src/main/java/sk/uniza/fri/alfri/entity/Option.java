package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "option")
public class Option {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('option_option_id_seq'")
  @Column(name = "option_id", nullable = false)
  private Integer id;

  @NotNull(message = "Option question cannot be null!")
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "question_id", nullable = false)
  private Question question;

  @Size(max = 100)
  @NotBlank(message = "Option's name cannot be blank or null!")
  @Column(name = "name", nullable = false, length = 100)
  private String name;
}
