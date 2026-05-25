package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.TeacherSubject;
import sk.uniza.fri.alfri.entity.TeacherSubjectId;
import sk.uniza.fri.alfri.projection.SubjectIdProjection;

import java.util.List;

public interface TeacherSubjectRepository extends JpaRepository<TeacherSubject, TeacherSubjectId> {
    List<SubjectIdProjection> findIdByIdTeacherId(Integer teacherId);
}
