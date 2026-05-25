package sk.uniza.fri.alfri.service;

import sk.uniza.fri.alfri.dto.datareport.DataReportDto;

/**
 * Service interface for data report operations
 */
public interface IDataReportService {

    /**
     * Get comprehensive data report for teacher dashboard
     * @param studyProgramId optional study program filter (null for all programs)
     * @return DataReportDto with all report data
     */
    DataReportDto getDataReport(Integer studyProgramId);
}

