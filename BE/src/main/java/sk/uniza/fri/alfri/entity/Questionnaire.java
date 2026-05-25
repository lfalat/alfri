package sk.uniza.fri.alfri.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "questionnaire")
public class Questionnaire {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('questionnaire_questionnaire_id_seq')")
    @Column(name = "questionnaire_id", nullable = false)
    private Integer id;

    @Size(max = 100)
    @NotBlank(message = "Questinnaire's title cannot be null or blank!")
    @Column(name = "title", nullable = false, length = 100)
    private String title;

    @NotBlank(message = "Questinnaire's description cannot be null or blank!")
    @Column(name = "description", nullable = false, length = Integer.MAX_VALUE)
    private String description;

    @NotNull(message = "Questinnaire's date of creation cannot be null!")
    @ColumnDefault("now()")
    @Column(name = "date_of_creation", nullable = false)
    private Instant dateOfCreation;

    @OneToMany(mappedBy = "questionnaire", fetch = FetchType.EAGER, cascade = CascadeType.ALL,
            orphanRemoval = true)
    @OrderBy("sectionId ASC")
    private List<QuestionnaireSection> sections = new ArrayList<>();

    @OneToMany(mappedBy = "answerQuestionnaire", fetch = FetchType.LAZY, cascade = CascadeType.ALL,
            orphanRemoval = true)
    private List<Answer> answers = new ArrayList<>();
}
