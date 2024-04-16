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
@Table(
    name = "\"user\"",
    uniqueConstraints = {
      @UniqueConstraint(
          name = "user_email_unique",
          columnNames = {"email"})
    })
public class User {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('user_user_id_seq'")
  @Column(name = "user_id", nullable = false)
  private Integer id;

  @NotNull
  @ManyToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "role_id", nullable = false)
  private Role role;

  @Size(max = 100)
  @NotNull
  @Column(name = "email", nullable = false, length = 100)
  private String email;

  @Size(max = 50)
  @NotNull
  @Column(name = "first_name", nullable = false, length = 50)
  private String firstName;

  @Size(max = 50)
  @NotNull
  @Column(name = "last_name", nullable = false, length = 50)
  private String lastName;

  @Size(max = 72)
  @NotNull
  @Column(name = "password", nullable = false, length = 72)
  private String password;

  @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
  private Set<Student> students = new LinkedHashSet<>();
}
