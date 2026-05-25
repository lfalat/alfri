package sk.uniza.fri.alfri.dto;

import org.springframework.data.domain.Sort;

public record StudentFilterDTO(Integer studyProgramId, Integer year, int page, int size, String sortBy, Sort.Direction direction) {}
