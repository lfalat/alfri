package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serial;
import java.util.Collection;
import java.util.List;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

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
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails {
  @Serial private static final long serialVersionUID = -1611510836045616813L;

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @ColumnDefault("nextval('user_user_id_seq'")
  @Column(name = "user_id", nullable = false)
  private Integer id;

  @NotNull(message = "User's role cannot be null!")
  @ManyToOne(optional = false)
  @JoinColumn(name = "role_id", nullable = false)
  @JsonManagedReference
  private Role role;

  @Size(max = 100)
  @NotBlank(message = "User's email cannot be blank or null!")
  @Column(name = "email", nullable = false, length = 100)
  private String email;

  @Size(max = 50)
  @NotBlank(message = "User's first name cannot be blank or null!")
  @Column(name = "first_name", nullable = false, length = 50)
  private String firstName;

  @Size(max = 50)
  @NotBlank(message = "User's last name cannot be blank or null!")
  @Column(name = "last_name", nullable = false, length = 50)
  private String lastName;

  @Size(max = 72)
  @NotBlank(message = "User's password cannot be blank or null!")
  @Column(name = "password", nullable = false, length = 72)
  private String password;

  @Column(name = "admin_rights", nullable = false, length = 5)
  private boolean adminRights;

  @OneToOne(mappedBy = "user")
  @JsonBackReference
  private transient Student student;

  /**
   * Returns the authorities granted to the user. Cannot return <code>null</code>.
   *
   * @return the authorities, sorted by natural key (never <code>null</code>)
   */
  @Override
  public Collection<? extends GrantedAuthority> getAuthorities() {
    return List.of();
  }

  /**
   * Returns the username used to authenticate the user. Cannot return <code>null</code>.
   *
   * @return the username (never <code>null</code>)
   */
  @Override
  public String getUsername() {
    return email;
  }

  /**
   * Indicates whether the user's account has expired. An expired account cannot be authenticated.
   *
   * @return <code>true</code> if the user's account is valid (ie non-expired), <code>false</code>
   *     if no longer valid (ie expired)
   */
  @Override
  public boolean isAccountNonExpired() {
    return true;
  }

  /**
   * Indicates whether the user is locked or unlocked. A locked user cannot be authenticated.
   *
   * @return <code>true</code> if the user is not locked, <code>false</code> otherwise
   */
  @Override
  public boolean isAccountNonLocked() {
    return true;
  }

  /**
   * Indicates whether the user's credentials (password) has expired. Expired credentials prevent
   * authentication.
   *
   * @return <code>true</code> if the user's credentials are valid (ie non-expired), <code>false
   *     </code> if no longer valid (ie expired)
   */
  @Override
  public boolean isCredentialsNonExpired() {
    return true;
  }

  /**
   * Indicates whether the user is enabled or disabled. A disabled user cannot be authenticated.
   *
   * @return <code>true</code> if the user is enabled, <code>false</code> otherwise
   */
  @Override
  public boolean isEnabled() {
    return true;
  }
}
