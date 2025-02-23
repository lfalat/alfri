import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import {
  FocusCategorySumDTO,
  KeywordDTO,
  Page, StudentYearCountDTO,
  SubjectDto,
  SubjectExtendedDto,
  SubjectGradesDto,
  SubjectPassingPrediction,
} from '../types';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class SubjectService {
  private readonly URL = `${environment.API_URL}/subject`;

  constructor(private http: HttpClient) {}

  public getSubjectsByStudyProgramId(
    studyProgramId: number,
    pageNumber: number,
    pageSize: number,
  ) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', `id.studyProgramId:${studyProgramId}`);

    return this.http.get<Page<SubjectDto>>(`${this.URL}`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

  public getMandatorySubjectsByStudyProgramIdAndYear(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number,
    studyYear: number,
  ) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', `id.studyProgramId:${studyProgramId},recommendedYear<${studyYear - 1},obligation:Pov.`);

    return this.http.get<Page<SubjectDto>>(`${this.URL}`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

  public getSubjectsWithFocusByStudyProgramId(
    studyProgramId: number,
    pageNumber: number,
    pageSize: number,
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
      .append('search', `id.studyProgramId:${studyProgramId}`);

    return this.http.get<Page<SubjectExtendedDto>>(`${this.URL}/withFocus`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

  public filterSubject(
    mathFocus: string,
    studyProgramId: number,
    pageNumber: number,
    pageSize: number,
  ) {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append(
        'search',
        `id.studyProgramId:${studyProgramId},id.subject.focus.mathFocus>${mathFocus}`,
      );

    return this.http.get<Page<SubjectDto>>(`${this.URL}`, {
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
    return this.http.post<SubjectDto[]>(
      `${this.URL}/similarSubjects`,
      subjects,
    );
  }

  public getSubjectFocusPrediction(): Observable<SubjectExtendedDto[]> {
    return this.http.get<SubjectExtendedDto[]>(`${this.URL}/focus-prediction`);
  }

  getFilteredSubjects(
    sortCriteria: string,
    subjectCount: number,
  ): Observable<SubjectGradesDto[]> {
    return this.http.get<SubjectGradesDto[]>(
      `${this.URL}/subjectReport?sortCriteria=${sortCriteria}&count=${subjectCount}`,
    );
  }

  public getLowestAverageSubjects(
    numberOfSubjects: number,
  ): Observable<SubjectGradesDto[]> {
    return this.http.get<SubjectGradesDto[]>(
      `${this.URL}/getHardestSubjects/${numberOfSubjects}`,
    );
  }

  public makeSubjectsPassingAndMarkPredictions(): Observable<
    SubjectPassingPrediction[]
  > {
    return this.http.get<SubjectPassingPrediction[]>(
      `${this.URL}/makePredictions`,
    );
  }

  public getSubjectsByKeywords(keywords: string[]): Observable<SubjectDto[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    const keywordsParam = keywords.join(',');

    const urlParameters: HttpParams = new HttpParams().set(
      'keywords',
      keywordsParam,
    );

    return this.http.get<SubjectDto[]>(`${this.URL}/subjects`, {
      params: urlParameters,
      headers: httpOptions.headers,
    });
  }

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
}
