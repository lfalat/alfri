package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Subject;

public interface SubjectRepository extends JpaRepository<Subject, Integer> {}
