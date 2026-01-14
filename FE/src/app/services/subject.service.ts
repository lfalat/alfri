import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import {
  Page,
  SubjectDto,
  SubjectExtendedDto,
  SubjectGradesDto,
  SubjectPassingPrediction,
  GradeAverageByYearDto,
} from '../types';
import { Observable } from 'rxjs';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class SubjectService {
  private readonly configService = inject(ConfigService);
  private readonly URL = `${this.configService.apiUrl()}/subject`;
  private readonly http = inject(HttpClient);

  public getSubjectsWithFocusByStudyProgramId(
    studyProgramId: number,
    pageNumber: number,
    pageSize: number,
    sort?: string,
  ): Observable<Page<SubjectExtendedDto>> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', `studyProgram.id:${studyProgramId}`);

    if (sort) {
      urlParameters = urlParameters.append('sort', sort);
    }

    return this.http.get<Page<SubjectExtendedDto>>(`${this.URL}/withFocus`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

  public getSubjectsWithFocusByStudyProgramIdAndSearch(
    pageNumber: number,
    pageSize: number,
    searchParam: string,
    sort?: string,
  ): Observable<Page<SubjectExtendedDto>> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', searchParam);

    if (sort) {
      urlParameters = urlParameters.append('sort', sort);
    }

    return this.http.get<Page<SubjectExtendedDto>>(`${this.URL}/withFocus`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

  public getExtendedSubjectByCode(subjectCode: string) {
    return this.http.get<SubjectExtendedDto>(`${this.URL}/${subjectCode}`);
  }

  public getSimilarSubjects(
    subjects: SubjectExtendedDto[],
  ): Observable<SubjectDto[]> {
    console.log(subjects);
    return this.http.post<SubjectDto[]>(
      `${this.URL}/similarSubjects`,
      subjects,
    );
  }

  public getSubjectFocusPrediction(
    pageNumber: number,
    pageSize: number,
    sort?: string,
  ): Observable<Page<SubjectExtendedDto>> {
    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize);

    if (sort) {
      urlParameters = urlParameters.append('sort', sort);
    }

    return this.http.get<Page<SubjectExtendedDto>>(
      `${this.URL}/focus-prediction`,
      { params: urlParameters },
    );
  }

  public getSubjectsWithGrades(
    pageNumber: number,
    pageSize: number,
    sort?: string,
  ): Observable<Page<SubjectGradesDto>> {
    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize);

    if (sort) {
      urlParameters = urlParameters.append('sort', sort);
    }

    return this.http.get<Page<SubjectGradesDto>>(
      `${this.URL}/with-grades`,
      { params: urlParameters },
    );
  }

  public makeSubjectsPassingAndMarkPredictions(): Observable<
    SubjectPassingPrediction[]
  > {
    return this.http.get<SubjectPassingPrediction[]>(
      `${this.URL}/makePredictions`,
    );
  }

  public getGradeAveragesByYear(
    subjectId: number,
  ): Observable<GradeAverageByYearDto[]> {
    return this.http.get<GradeAverageByYearDto[]>(
      `${this.URL}/${subjectId}/grade-averages-by-year`,
    );
  }
}
