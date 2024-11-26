package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Department;

public interface DepartmentRepository extends JpaRepository<Department, Integer> {
}
