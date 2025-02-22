package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.entity.SubjectGradeCorrelation;

import java.util.List;

public interface SubjectGradeCorrelationService {
    List<SubjectGradeCorrelation> findAll();

    List<SubjectGradeCorrelation> findAllWithCorrelation(double correlationTreshold, String operator);
}
