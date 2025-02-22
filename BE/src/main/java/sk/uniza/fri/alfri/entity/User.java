package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serial;
import java.util.Collection;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "\"user\"",
        uniqueConstraints = {@UniqueConstraint(name = "user_email_unique", columnNames = {"email"})})
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails {
    @Serial
    private static final long serialVersionUID = -1611510836045616813L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('user_user_id_seq'")
    @Column(name = "user_id", nullable = false)
    private Integer id;

    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    private List<UserRole> userRoles;

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

    @OneToOne(mappedBy = "user", fetch = FetchType.EAGER)
    @JsonBackReference
    private Student student;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return userRoles.stream().map(UserRole::getRole).toList();
    }

    @Override
    public String getUsername() {
        return email;
    }
}
