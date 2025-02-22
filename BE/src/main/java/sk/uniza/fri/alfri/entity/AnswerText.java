package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@Setter
@Table(name = "answer_text")
public class AnswerText {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "answer_text_id")
    @ColumnDefault("nextval('answer_text_answer_text_id_seq')")
    private int answerTextId;

    @Column(name = "answer_text", nullable = false)
    private String textOfAnswer;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "answer_id", nullable = false)
    @JsonBackReference
    private Answer answer;
}
