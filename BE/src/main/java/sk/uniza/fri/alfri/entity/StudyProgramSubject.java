package sk.uniza.fri.alfri.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "study_program_subject")
public class StudyProgramSubject {
  @EmbeddedId private StudyProgramSubjectId id;
}
