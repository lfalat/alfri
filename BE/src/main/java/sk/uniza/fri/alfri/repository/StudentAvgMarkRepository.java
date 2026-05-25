package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import sk.uniza.fri.alfri.entity.StudentAvgMark;

@Repository
public interface StudentAvgMarkRepository extends JpaRepository<StudentAvgMark, Integer>  {
}
