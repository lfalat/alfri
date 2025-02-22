package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "student")
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "student_id", nullable = false)
    private Integer id;

    @OneToOne()
    @JoinColumn(name = "user_id")
    private User user;

    @NotNull(message = "Student's studyProgramId cannot be null!")
    @Column(name = "study_program_id", nullable = false)
    private Integer studyProgramId;

    @NotNull(message = "Student's year cannot be null!")
    @Positive(message = "Student's year must be positive number!")
    @Column(name = "year", nullable = false)
    private Integer year;
}
