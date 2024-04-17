package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import sk.uniza.fri.alfri.entity.OptionOptionsAnswer;
import sk.uniza.fri.alfri.entity.OptionOptionsAnswerId;

public interface IOptionOptionsAnswerRepository
    extends JpaRepository<OptionOptionsAnswer, OptionOptionsAnswerId> {}
