import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import {
  FocusCategorySumDTO,
  KeywordDTO,
  StudentAverageGradePageResponse,
  StudentFilterDTO,
  StudentYearCountDTO,
} from '../types';
import { Observable } from 'rxjs';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class LeadService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/lead`;

  public getAllKeywords(): Observable<KeywordDTO[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<KeywordDTO[]>(`${this.URL}/all-keywords`, {
      headers: httpOptions.headers,
    });
  }

  public getCategorySums(): Observable<FocusCategorySumDTO[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<FocusCategorySumDTO[]>(`${this.URL}/category-sums`, {
      headers: httpOptions.headers,
    });
  }

  public getStudentCountsByYear(): Observable<StudentYearCountDTO[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<StudentYearCountDTO[]>(`${this.URL}/counts-by-year`, {
      headers: httpOptions.headers,
    });
  }

  getStudentPerformanceReport(
    filter: StudentFilterDTO,
  ): Observable<StudentAverageGradePageResponse> {
    // Convert the filter object to HTTP query parameters
    let params = new HttpParams()
      .set('page', filter.page.toString())
      .set('size', filter.size.toString())
      .set('sortBy', filter.sortBy)
      .set('direction', filter.direction);

    if (filter.studyProgramId !== undefined) {
      params = params.set('studyProgramId', filter.studyProgramId.toString());
    }

    if (filter.year !== undefined) {
      params = params.set('year', filter.year.toString());
    }

    // Make the GET request
    return this.http.get<StudentAverageGradePageResponse>(
      `${this.URL}/report/student-performance`,
      { params },
    );
  }
}
