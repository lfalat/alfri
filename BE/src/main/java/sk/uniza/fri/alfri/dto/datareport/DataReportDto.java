package sk.uniza.fri.alfri.dto.datareport;

import java.io.Serializable;
import java.util.List;

/**
 * DTO for comprehensive data report for the Teacher Home Dashboard
 */
public record DataReportDto(
        Long studentCount,
        Long subjectCount,
        Long studyProgramCount,
        List<StudentTrendDataPoint> studentTrend,
        List<StudentsPerYear> studentsPerYear,
        List<AverageGradeDataPoint> averageGradeByYear,
        List<GradeDistribution> gradeDistribution
) implements Serializable {
}
