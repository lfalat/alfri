package sk.uniza.fri.alfri.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.core.GrantedAuthority;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "role")
public class Role implements Serializable, GrantedAuthority {
    @Serial
    private static final long serialVersionUID = -5613856421859237857L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('role_role_id_seq'")
    @Column(name = "role_id", nullable = false)
    private Integer id;

    @Size(max = 50)
    @NotBlank(message = "Role's name cannot be blank or null!")
    @Column(name = "name", nullable = false, length = 50)
    private String name;

    @OneToMany(mappedBy = "role", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<UserRole> userRoles;

    @Override
    public String getAuthority() {
        return "ROLE_" + name.toUpperCase();
    }

    @Override
    public String toString() {
        return "ROLE_" + name.toUpperCase();
    }
}
