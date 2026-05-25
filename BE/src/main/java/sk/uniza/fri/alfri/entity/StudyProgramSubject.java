package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.proxy.HibernateProxy;

import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Entity
@Table(name = "study_program_subject")
public class StudyProgramSubject implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('subject_study_program_id_seq')")
    @Column(name = "subject_study_program_id", nullable = false)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "subject_id", nullable = false)
    @NotNull(message = "Subject cannot be null!")
    @JsonBackReference
    private Subject subject;

    @ManyToOne
    @JoinColumn(name = "study_program_id", nullable = false)
    @NotNull(message = "Study program cannot be null!")
    @JsonBackReference
    private StudyProgram studyProgram;

    @Column(name = "obligation", nullable = false, length = 4)
    @NotBlank(message = "StudyProgramSubject's obligation cannot be null or blank!")
    private String obligation;

    @Column(name = "recommended_year", nullable = false)
    @NotNull(message = "Recommended year for subject must not be null!")
    @Positive(message = "Recommended year for subject must be positive!")
    private Integer recommendedYear;

    @Column(name = "semester_winter", nullable = false)
    @NotNull(message = "Semester winter for subject must not be null!")
    private Boolean semesterWinter;


    @Override
    public final boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null)
            return false;
        if (!this.getClass().equals(o.getClass()))
            return false;
        Class<?> oEffectiveClass = o instanceof HibernateProxy hibernateProxy
                ? hibernateProxy.getHibernateLazyInitializer().getPersistentClass()
                : o.getClass();
        Class<?> thisEffectiveClass = this instanceof HibernateProxy hibernateProxy
                ? hibernateProxy.getHibernateLazyInitializer().getPersistentClass()
                : this.getClass();
        if (thisEffectiveClass != oEffectiveClass)
            return false;
        StudyProgramSubject that = (StudyProgramSubject) o;
        return getId() != null && Objects.equals(getId(), that.getId());
    }

    @Override
    public final int hashCode() {
        return Objects.hash(id);
    }
}
