package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Embeddable
public class TeacherSubjectId implements Serializable {
    @Serial
    private static final long serialVersionUID = 5532280457975789462L;

    @NotNull
    @Column(name = "teacher_id", nullable = false)
    private Integer teacherId;

    @NotNull
    @Column(name = "subject_id", nullable = false)
    private Integer subjectId;

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o))
            return false;
        TeacherSubjectId entity = (TeacherSubjectId) o;
        return Objects.equals(this.teacherId, entity.teacherId)
                && Objects.equals(this.subjectId, entity.subjectId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(teacherId, subjectId);
    }
}
