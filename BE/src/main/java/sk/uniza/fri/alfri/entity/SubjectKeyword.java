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
    private Integer id; // If you want to manage an ID, otherwise remove this if it's unnecessary.

    @NotNull
    @Column(name = "keyword", nullable = false)
    private String keyword;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_code1", referencedColumnName = "code", nullable = true)
    private Subject subjectCode1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_code2", referencedColumnName = "code", nullable = true)
    private Subject subjectCode2;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_code3", referencedColumnName = "code", nullable = true)
    private Subject subjectCode3;

}