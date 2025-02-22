package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Subject;

import java.util.List;

public interface SubjectRepository extends JpaRepository<Subject, Integer> {
    Subject findSubjectByCode(String code);

    List<Subject> findByCodeIn(List<String> codes);
}
