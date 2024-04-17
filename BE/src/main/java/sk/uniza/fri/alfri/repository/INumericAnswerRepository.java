package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.NumericAnswer;
import sk.uniza.fri.alfri.entity.NumericAnswerId;

public interface INumericAnswerRepository extends JpaRepository<NumericAnswer, NumericAnswerId> {}
