package sk.uniza.fri.alfri.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "subject_keyword", schema = "public")
public class SubjectKeyword {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "keyword_id", nullable = false)
    private Integer id;

    @NotNull
    @Column(name = "keyword", nullable = false)
    private String keyword;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_1", referencedColumnName = "subject_id", nullable = true)
    private Subject subject1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_2", referencedColumnName = "subject_id", nullable = true)
    private Subject subject2;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_3", referencedColumnName = "subject_id", nullable = true)
    private Subject subject3;

}