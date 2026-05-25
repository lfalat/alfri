package sk.uniza.fri.alfri.entity;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "questionnaire_section")
@FilterDef(name = "answeredByUserFilter", parameters = @ParamDef(name = "userId", type = Integer.class))
public class QuestionnaireSection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnDefault("nextval('questionnaire_section_id_seq')")
    @Column(name = "section_id", nullable = false)
    private Integer sectionId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "questionnaire_id", nullable = false)
    private Questionnaire questionnaire;

    @Basic
    @Column(name = "section_title")
    private String sectionTitle;

    @Basic
    @Column(name = "section_description")
    private String sectionDescription;

    @Basic
    @Column(name = "should_fetch_data")
    private Boolean shouldFetchData;

    @OneToMany(mappedBy = "questionnaireSection", fetch = FetchType.EAGER, cascade = CascadeType.ALL,
            orphanRemoval = true)
    @Filter(name = "answeredByUserFilter", condition = "EXISTS (SELECT 1 FROM answer a WHERE a.question_id = question_id AND a.user_id = :userId)")
    private List<Question> questions = new ArrayList<>();
}
