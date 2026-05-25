package sk.uniza.fri.alfri.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import sk.uniza.fri.alfri.dto.datareport.DataReportDto;
import sk.uniza.fri.alfri.service.IDataReportService;

/**
 * REST controller for data report endpoints
 */
@RestController
@RequestMapping("/api/data-report")
@PreAuthorize("hasAnyRole('ROLE_TEACHER', 'ROLE_ADMIN', 'ROLE_VEDENIE')")
@Tag(name = "Data Report", description = "API endpoints for teacher dashboard data reports and analytics")
@Slf4j
public class DataReportController {

    private final IDataReportService dataReportService;

    public DataReportController(IDataReportService dataReportService) {
        this.dataReportService = dataReportService;
    }

    /**
     * Get comprehensive data report for teacher dashboard
     *
     * @param studyProgramId Optional study program ID filter.
     *                       If null, returns aggregated data across all study programs.
     *                       If provided, returns data filtered for the specified study program only.
     * @return DataReportDto containing all report metrics
     */
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<DataReportDto> getDataReport(
            @RequestParam(required = false) Integer studyProgramId) {
        DataReportDto report = dataReportService.getDataReport(studyProgramId);
        return ResponseEntity.ok(report);
    }
}

