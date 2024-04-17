package sk.uniza.fri.alfri.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.User;

public interface UserRepository extends JpaRepository<User, Integer> {
  Optional<User> findByEmail(String email);
}
