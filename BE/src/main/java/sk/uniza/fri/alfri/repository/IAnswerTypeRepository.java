package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.AnswerType;

public interface IAnswerTypeRepository extends JpaRepository<AnswerType, Integer> {}
