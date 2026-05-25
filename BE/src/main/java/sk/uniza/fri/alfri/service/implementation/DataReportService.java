package sk.uniza.fri.alfri.service.implementation;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import sk.uniza.fri.alfri.dto.datareport.*;
import sk.uniza.fri.alfri.repository.DataReportRepository;
import sk.uniza.fri.alfri.repository.projection.*;
import sk.uniza.fri.alfri.service.IDataReportService;

import java.time.Year;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service implementation for data report operations
 */
@Service
@Slf4j
public class DataReportService implements IDataReportService {

    private static final int YEARS_LOOKBACK = 7;
    private final DataReportRepository dataReportRepository;

    public DataReportService(DataReportRepository dataReportRepository) {
        this.dataReportRepository = dataReportRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public DataReportDto getDataReport(Integer studyProgramId) {
        log.info("Generating data report for study program: {}", studyProgramId == null ? "ALL" : studyProgramId);

        int currentYear = Year.now().getValue();
        int startYear = currentYear - YEARS_LOOKBACK;

        log.info("Date parameters: currentYear={}, startYear={}, lookback={} years",
                currentYear, startYear, YEARS_LOOKBACK);

        // Get all counts
        Long studentCount = dataReportRepository.countStudents(studyProgramId);
        Long subjectCount = dataReportRepository.countSubjects(studyProgramId);
        Long studyProgramCount = dataReportRepository.countStudyPrograms(studyProgramId);

        log.info("Counts: students={}, subjects={}, programs={}",
                studentCount, subjectCount, studyProgramCount);

        // Get student trends
        List<StudentTrendDataPoint> studentTrend = buildStudentTrend(studyProgramId, startYear);

        // Get students per year distribution
        List<StudentsPerYear> studentsPerYear = buildStudentsPerYear(studyProgramId);

        // Get average grades by year
        List<AverageGradeDataPoint> averageGradeByYear = buildAverageGradeByYear(studyProgramId, startYear);

        // Get grade distribution
        List<GradeDistribution> gradeDistribution = buildGradeDistribution(studyProgramId);

        log.info("Data report generated successfully: {} students, {} subjects, {} programs",
                studentCount, subjectCount, studyProgramCount);

        return new DataReportDto(
                studentCount,
                subjectCount,
                studyProgramCount,
                studentTrend,
                studentsPerYear,
                averageGradeByYear,
                gradeDistribution
        );
    }

    /**
     * Build student trend data points grouped by calendar year and study program
     * Returns cumulative sums - each year shows total enrolled students up to that year
     */
    private List<StudentTrendDataPoint> buildStudentTrend(Integer studyProgramId, int startYear) {
        List<StudentTrendProjection> rawData = dataReportRepository.getStudentTrendByYear(studyProgramId, startYear);
        log.debug("Student trend raw data size: {}", rawData.size());

        // Group by calendar year and collect program counts
        Map<Integer, Map<Integer, Integer>> trendMap = new HashMap<>();

        for (StudentTrendProjection trend : rawData) {
            Integer calendarYear = trend.getCalendarYear();
            Integer programId = trend.getStudyProgramId();
            Long count = trend.getCount();

            log.debug("Student trend entry: calendarYear={}, programId={}, count={}",
                    calendarYear, programId, count);

            trendMap.computeIfAbsent(calendarYear, y -> new HashMap<>())
                    .put(programId, count.intValue());
        }

        // Get all program IDs and sort years
        Set<Integer> allPrograms = trendMap.values().stream()
                .flatMap(map -> map.keySet().stream())
                .collect(Collectors.toSet());

        List<Integer> sortedYears = trendMap.keySet().stream()
                .sorted()
                .toList();

        // Calculate cumulative sums for each program
        Map<Integer, Integer> cumulativeCounts = new HashMap<>();
        for (Integer program : allPrograms) {
            cumulativeCounts.put(program, 0);
        }

        List<StudentTrendDataPoint> result = new ArrayList<>();
        for (Integer year : sortedYears) {
            Map<Integer, Integer> yearData = trendMap.get(year);
            Map<Integer, Integer> cumulativeYearData = new HashMap<>();

            // Update cumulative counts and create snapshot for this year
            for (Integer program : allPrograms) {
                int yearCount = yearData.getOrDefault(program, 0);
                int newCumulative = cumulativeCounts.get(program) + yearCount;
                cumulativeCounts.put(program, newCumulative);
                cumulativeYearData.put(program, newCumulative);

                log.debug("Cumulative for year={}, programId={}: yearCount={}, cumulative={}",
                        year, program, yearCount, newCumulative);
            }

            result.add(new StudentTrendDataPoint(year, cumulativeYearData));
        }

        log.info("Built {} cumulative student trend data points", result.size());
        return result;
    }

    /**
     * Build students per year level distribution
     * Years 1-3 shown as is, year 4+ shown as "Finished"
     */
    private List<StudentsPerYear> buildStudentsPerYear(Integer studyProgramId) {
        List<StudentsPerYearProjection> rawData = dataReportRepository.getStudentsPerYear(studyProgramId);

        return rawData.stream()
                .map(projection -> {
                    Integer yearValue = projection.getYear();
                    Long count = projection.getCount();
                    String yearLabel = yearValue == 4 ? "Finished" : String.valueOf(yearValue);
                    return new StudentsPerYear(yearLabel, count);
                }).toList();
    }

    /**
     * Build average grade data points by calendar year and student year level
     */
    private List<AverageGradeDataPoint> buildAverageGradeByYear(Integer studyProgramId, int startYear) {
        List<AverageGradeProjection> rawData = dataReportRepository.getAverageGradesByYearAndStudentYear(studyProgramId, startYear);
        log.debug("Average grades raw data size: {}", rawData.size());

        // Group by calendar year and collect averages for each student year level
        Map<Integer, Map<Integer, Double>> gradeMap = new HashMap<>();

        for (AverageGradeProjection projection : rawData) {
            Integer calendarYear = projection.getCalendarYear();
            Integer studentYearLevel = projection.getStudentYearLevel();
            Double avgGrade = projection.getAvgGrade();

            log.debug("Average grade entry: calendarYear={}, studentYearLevel={}, avgGrade={}",
                    calendarYear, studentYearLevel, avgGrade);

            gradeMap.computeIfAbsent(calendarYear, y -> new HashMap<>())
                    .put(studentYearLevel, avgGrade);
        }

        // Convert to list of AverageGradeDataPoint
        List<AverageGradeDataPoint> result = gradeMap.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .map(entry -> new AverageGradeDataPoint(
                        entry.getKey(),
                        entry.getValue().get(1),
                        entry.getValue().get(2),
                        entry.getValue().get(3),
                        entry.getValue().get(4),
                        entry.getValue().get(5)
                ))
                .toList();

        log.info("Built {} average grade data points", result.size());
        return result;
    }

    /**
     * Build grade distribution across all students
     */
    private List<GradeDistribution> buildGradeDistribution(Integer studyProgramId) {
        List<GradeDistributionProjection> rawData = dataReportRepository.getGradeDistribution(studyProgramId);
        log.debug("Grade distribution raw data size: {}", rawData.size());

        // Ensure all grades are present (even with 0 count)
        Map<String, Long> gradeMap = new LinkedHashMap<>();
        gradeMap.put("A", 0L);
        gradeMap.put("B", 0L);
        gradeMap.put("C", 0L);
        gradeMap.put("D", 0L);
        gradeMap.put("E", 0L);
        gradeMap.put("FX", 0L);

        // Fill with actual data
        for (GradeDistributionProjection projection : rawData) {
            String grade = projection.getGrade();
            Long count = projection.getCount();
            log.debug("Grade distribution entry: grade={}, count={}", grade, count);
            gradeMap.put(grade, count);
        }

        List<GradeDistribution> result = gradeMap.entrySet().stream()
                .map(entry -> new GradeDistribution(entry.getKey(), entry.getValue()))
                .toList();

        log.info("Built grade distribution with {} entries", result.size());
        return result;
    }
}

