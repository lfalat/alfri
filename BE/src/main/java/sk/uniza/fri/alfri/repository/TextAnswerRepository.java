package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.TextAnswer;
import sk.uniza.fri.alfri.entity.TextAnswerId;

public interface TextAnswerRepository extends JpaRepository<TextAnswer, TextAnswerId> {}
