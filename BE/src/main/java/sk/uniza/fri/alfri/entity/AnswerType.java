package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Getter
@Setter
@Entity
@Table(name = "answer_type")
public class AnswerType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('answer_type_answer_type_id_seq'")
    @Column(name = "answer_type_id", nullable = false)
    private Integer id;

    @Size(max = 50)
    @NotBlank(message = "Answer type name cannot be blank or empty!")
    @Column(name = "name", nullable = false, length = 50)
    private sk.uniza.fri.alfri.dto.questionnaire.AnswerType name;
}
