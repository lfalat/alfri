package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Student;

public interface StudentRepository extends JpaRepository<Student, Integer> {}
