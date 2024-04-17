package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.Option;

public interface IOptionRepository extends JpaRepository<Option, Integer> {}
