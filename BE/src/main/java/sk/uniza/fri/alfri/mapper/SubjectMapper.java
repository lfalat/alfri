package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import sk.uniza.fri.alfri.dto.subject.SubjectDTO;
import sk.uniza.fri.alfri.entity.Subject;

import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = {FocusMapper.class})
public interface SubjectMapper {
    SubjectDTO subjectToSubjectDTO(Subject subject);

    List<SubjectDTO> subjectsToSubjectDTOList(List<Subject> subjects);
}
