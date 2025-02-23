package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.ParamDef;

@Setter
@Getter
@Entity
@Immutable
@Table(name = "student_avg_marks")
@FilterDef(
        name = "studyProgramFilter",
        parameters = @ParamDef(name = "studyProgramId", type = Integer.class)
)
@Filter(
        name = "studyProgramFilter",
        condition = "student_id IN (SELECT s.student_id FROM student s WHERE s.study_program_id = :studyProgramId)"
)
@FilterDef(
        name = "yearFilter",
        parameters = @ParamDef(name = "year", type = Integer.class)
)
@Filter(
        name = "yearFilter",
        condition = "student_id IN (SELECT s.student_id FROM student s WHERE s.year = :year)"
)
public class StudentAvgMark {
    @Id
    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "avgmark", nullable = false)
    private Double avgMark;

    @NotNull
    @OneToOne
    @JoinColumn(name = "student_id", insertable = false, updatable = false)
    private Student student;
}
