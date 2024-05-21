package sk.uniza.fri.alfri.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import sk.uniza.fri.alfri.dto.focus.FocusDTO;
import sk.uniza.fri.alfri.entity.Focus;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface FocusMapper {
    FocusDTO focusToFocusDTO(Focus focus);
}
