package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.core.GrantedAuthority;

@Getter
@Setter
@Entity
@Table(name = "role")
public class Role implements Serializable, GrantedAuthority {
  @Serial private static final long serialVersionUID = -5613856421859237857L;

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
  private List<User> users = new ArrayList<>();

  /**
   * If the <code>GrantedAuthority</code> can be represented as a <code>String</code> and that
   * <code>String</code> is sufficient in precision to be relied upon for an access control decision
   * by an {@link AccessDecisionManager} (or delegate), this method should return such a <code>
   * String</code>.
   *
   * <p>If the <code>GrantedAuthority</code> cannot be expressed with sufficient precision as a
   * <code>String</code>, <code>null</code> should be returned. Returning <code>null</code> will
   * require an <code>AccessDecisionManager</code> (or delegate) to specifically support the <code>
   * GrantedAuthority</code> implementation, so returning <code>null</code> should be avoided unless
   * actually required.
   *
   * @return a representation of the granted authority (or <code>null</code> if the granted
   *     authority cannot be expressed as a <code>String</code> with sufficient precision).
   */
  @Override
  public String getAuthority() {
    return "ROLE_" + name.toUpperCase();
  }

  @Override
  public String toString() {
    return "ROLE_" + name.toUpperCase();
  }
}
