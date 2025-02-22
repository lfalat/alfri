package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "subject_grades", schema = "public")
public class SubjectGrade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subject_id", nullable = false)
    private Integer id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "subject_id", nullable = false)
    private Subject subject;

    @NotNull
    @Column(name = "grade_a", nullable = false)
    private Float gradeA;

    @NotNull
    @Column(name = "grade_b", nullable = false)
    private Float gradeB;

    @NotNull
    @Column(name = "grade_c", nullable = false)
    private Float gradeC;

    @NotNull
    @Column(name = "grade_d", nullable = false)
    private Float gradeD;

    @Column(name = "grade_e")
    private Float gradeE;

    @Column(name = "grade_fx")
    private Float gradeFx;

    @NotNull
    @Column(name = "students_count", nullable = false)
    private Integer studentsCount;

    @NotNull
    @Column(name = "grade_average", nullable = false)
    private Float gradeAverage;
}
