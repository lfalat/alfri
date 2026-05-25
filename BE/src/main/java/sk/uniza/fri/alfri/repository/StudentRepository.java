package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Student;

import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Integer> {
    Optional<Student> findByUser_Email(String userEmail);
}
