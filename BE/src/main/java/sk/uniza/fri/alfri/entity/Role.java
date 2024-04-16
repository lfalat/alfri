package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "role")
public class Role {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('role_role_id_seq'")
  @Column(name = "role_id", nullable = false)
  private Integer id;

  @Size(max = 50)
  @NotNull
  @Column(name = "name", nullable = false, length = 50)
  private String name;

  @OneToMany(mappedBy = "role", fetch = FetchType.LAZY)
  private Set<User> users = new LinkedHashSet<>();
}
