package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.StudentSubject;
import sk.uniza.fri.alfri.entity.StudentSubjectId;

public interface StudentSubjectRepository
    extends JpaRepository<StudentSubject, StudentSubjectId> {}
