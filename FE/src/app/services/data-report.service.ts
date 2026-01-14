import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { DataReportDto, StudyProgramId } from '../types';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class DataReportService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/data-report`;

  public getDataReport(
    studyProgramId: StudyProgramId | null,
  ): Observable<DataReportDto> {
    let params = new HttpParams();

    if (studyProgramId) {
      params = params.set('studyProgramId', studyProgramId.toString());
    }

    return this.http.get<DataReportDto>(this.URL, { params });
  }
}
