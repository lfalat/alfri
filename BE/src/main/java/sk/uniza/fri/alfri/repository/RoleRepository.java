package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Role;

public interface RoleRepository extends JpaRepository<Role, Integer> {}
