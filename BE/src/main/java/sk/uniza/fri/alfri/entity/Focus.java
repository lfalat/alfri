package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@Entity
@Table(name = "focus")
public class Focus implements Serializable {
    @Serial
    private static final long serialVersionUID = -9188932193400358754L;

    @Id
    @Column(name = "subject_id", nullable = false)
    private Integer id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "subject_id", nullable = false)
    @JsonManagedReference
    private Subject subject;

    @NotNull(message = "Math focus cannot be null!")
    @Column(name = "math_focus", nullable = false)
    private Integer mathFocus;

    @NotNull(message = "Logic focus cannot be null!")
    @Column(name = "logic_focus", nullable = false)
    private Integer logicFocus;

    @NotNull(message = "Programming focus cannot be null!")
    @Column(name = "programming_focus", nullable = false)
    private Integer programmingFocus;

    @NotNull(message = "Design focus cannot be null!")
    @Column(name = "design_focus", nullable = false)
    private Integer designFocus;

    @NotNull(message = "Economics focus cannot be null!")
    @Column(name = "economics_focus", nullable = false)
    private Integer economicsFocus;

    @NotNull(message = "Management focus cannot be null!")
    @Column(name = "management_focus", nullable = false)
    private Integer managementFocus;

    @NotNull(message = "Hardware focus cannot be null!")
    @Column(name = "hardware_focus", nullable = false)
    private Integer hardwareFocus;

    @NotNull(message = "Network focus cannot be null!")
    @Column(name = "network_focus", nullable = false)
    private Integer networkFocus;

    @NotNull(message = "Data focus cannot be null!")
    @Column(name = "data_focus", nullable = false)
    private Integer dataFocus;

    @NotNull(message = "Testing focus cannot be null!")
    @Column(name = "testing_focus", nullable = false)
    private Integer testingFocus;

    @NotNull(message = "Language focus cannot be null!")
    @Column(name = "language_focus", nullable = false)
    private Integer languageFocus;

    @NotNull(message = "Physical focus cannot be null!")
    @Column(name = "physical_focus", nullable = false)
    private Integer physicalFocus;
}
