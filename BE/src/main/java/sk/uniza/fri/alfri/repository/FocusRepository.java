package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Focus;

public interface FocusRepository extends JpaRepository<Focus, Integer> {}