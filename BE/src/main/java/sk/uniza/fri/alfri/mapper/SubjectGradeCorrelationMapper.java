package sk.uniza.fri.alfri.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants.ComponentModel;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.mapstruct.ReportingPolicy;
import sk.uniza.fri.alfri.dto.SubjectGradeCorrelationDto;
import sk.uniza.fri.alfri.entity.SubjectGradeCorrelation;

@Mapper(unmappedTargetPolicy = ReportingPolicy.IGNORE, componentModel = ComponentModel.SPRING,
        uses = {SubjectMapper.class})
public interface SubjectGradeCorrelationMapper {
    SubjectGradeCorrelation toEntity(SubjectGradeCorrelationDto subjectGradeCorrelationDto);

    SubjectGradeCorrelationDto toDto(SubjectGradeCorrelation subjectGradeCorrelation);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    SubjectGradeCorrelation partialUpdate(SubjectGradeCorrelationDto subjectGradeCorrelationDto,
                                          @MappingTarget SubjectGradeCorrelation subjectGradeCorrelation);
}
