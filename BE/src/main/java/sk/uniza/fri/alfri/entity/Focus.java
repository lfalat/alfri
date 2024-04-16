package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "focus")
public class Focus {
  @Id
  @Column(name = "subject_id", nullable = false)
  private Integer id;

  @MapsId
  @OneToOne(fetch = FetchType.LAZY, optional = false)
  @JoinColumn(name = "subject_id", nullable = false)
  private Subject subject;

  @NotNull
  @Column(name = "math_focus", nullable = false)
  private Integer mathFocus;

  @NotNull
  @Column(name = "logic_focus", nullable = false)
  private Integer logicFocus;

  @NotNull
  @Column(name = "programming_focus", nullable = false)
  private Integer programmingFocus;

  @NotNull
  @Column(name = "design_focus", nullable = false)
  private Integer designFocus;

  @NotNull
  @Column(name = "economics_focus", nullable = false)
  private Integer economicsFocus;

  @NotNull
  @Column(name = "management_focus", nullable = false)
  private Integer managementFocus;

  @NotNull
  @Column(name = "hardware_focus", nullable = false)
  private Integer hardwareFocus;

  @NotNull
  @Column(name = "network_focus", nullable = false)
  private Integer networkFocus;

  @NotNull
  @Column(name = "data_focus", nullable = false)
  private Integer dataFocus;

  @NotNull
  @Column(name = "testing_focus", nullable = false)
  private Integer testingFocus;

  @NotNull
  @Column(name = "language_focus", nullable = false)
  private Integer languageFocus;

  @NotNull
  @Column(name = "physical_focus", nullable = false)
  private Integer physicalFocus;
}
