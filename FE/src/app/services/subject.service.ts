import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Page, SubjectDto } from '../types';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class SubjectService {
  private readonly URL = 'http://localhost:8080/api/subject';

  constructor(private http: HttpClient) {
  }

  public getSubjectsByStudyProgramId(
    studyProgramId: number,
    pageNumber: number,
    pageSize: number
  ): Observable<Page<SubjectDto>> {
    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', `id.studyProgramId:${ studyProgramId }`);

    return this.http.get<Page<SubjectDto>>(`${ this.URL }`, {
      params: urlParameters,
    });
  }

  public filterSubject(mathFocus: string, studyProgramId: number, pageNumber: number, pageSize: number): Observable<Page<SubjectDto>> {
    let urlParameters: HttpParams = new HttpParams();
    urlParameters = urlParameters
      .append('page', pageNumber)
      .append('size', pageSize)
      .append('search', `id.studyProgramId:${ studyProgramId },id.subject.focus.mathFocus>${mathFocus}`);

    return this.http.get<Page<SubjectDto>>(`${ this.URL }`, {
      params: urlParameters,
    });
  }
}
