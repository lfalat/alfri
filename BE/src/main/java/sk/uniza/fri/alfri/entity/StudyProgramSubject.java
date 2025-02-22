package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.proxy.HibernateProxy;

import java.util.Objects;

@Getter
@Setter
@Entity
@Table(name = "study_program_subject")
public class StudyProgramSubject {
    @EmbeddedId
    private StudyProgramSubjectId id;

    @Column(name = "obligation")
    @NotBlank(message = "StudyProgramSubject's obligation cannot be null or blank!")
    private String obligation;

    @Column(name = "recommended_year")
    @NotNull(message = "Recommended year for subject must not be null!")
    @Positive(message = "Recommended year for subject must be positive!")
    private Integer recommendedYear;

    @Column(name = "semester_winter")
    @NotNull(message = "Semester winter for subject must not be null!")
    private Boolean semesterWinter;

    @ManyToOne
    @JoinColumn(name = "subject_id", insertable = false, updatable = false)
    private Subject subject;

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
