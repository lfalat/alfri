package sk.uniza.fri.alfri.dto.subject;

import lombok.Data;
import sk.uniza.fri.alfri.dto.focus.FocusDTO;

@Data
public class SubjectDTO {

    Integer id;
    String name;
    String code;
    String abbreviation;
    FocusDTO focus;
}
