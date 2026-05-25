package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "subject_grade_correlation", schema = "public")
public class SubjectGradeCorrelation {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
            generator = "subject_grade_correlation_id_gen")
    @SequenceGenerator(name = "subject_grade_correlation_id_gen",
            sequenceName = "subject_grade_correlation_id_seq", allocationSize = 1)
    @Column(name = "id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "first_subject")
    private Subject firstSubject;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "second_subject")
    private Subject secondSubject;

    @NotNull
    @Column(name = "correlation", nullable = false)
    private Double correlation;
}
