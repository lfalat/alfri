package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.OptionsAnswer;
import sk.uniza.fri.alfri.entity.OptionsAnswerId;

public interface IOptionsAnswerRepository extends JpaRepository<OptionsAnswer, OptionsAnswerId> {}
