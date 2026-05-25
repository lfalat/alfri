package sk.uniza.fri.alfri.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Entity
@Table(name = "study_program")
public class StudyProgram {

    @Id
    @Column(name = "study_program_id", nullable = false)
    private Integer id;

    @Size(max = 100)
    @NotBlank(message = "StudyProgram's name cannot be blank or null!")
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @OneToMany(mappedBy = "studyProgram", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonBackReference
    private List<StudyProgramSubject> studyProgramSubjects;
}
