package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Subject;

public interface ISubjectRepository extends JpaRepository<Subject, Integer> {}
