package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.io.Serial;
import java.io.Serializable;
import java.util.LinkedHashSet;
import java.util.Set;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "role")
public class Role implements Serializable {
  @Serial private static final long serialVersionUID = 5684886028769478945L;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('role_role_id_seq'")
  @Column(name = "role_id", nullable = false)
  private Integer id;

  @Size(max = 50)
  @NotBlank(message = "Role's name cannot be blank or null!")
  @Column(name = "name", nullable = false, length = 50)
  private String name;

  @OneToMany(mappedBy = "role", fetch = FetchType.LAZY)
  @JsonBackReference
  private Set<User> users = new LinkedHashSet<>();
}
