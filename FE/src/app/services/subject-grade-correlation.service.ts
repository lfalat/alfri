import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { SubjectGradeCorrelation } from '../types';
import { Operator } from '../enums/operator';

@Injectable({
  providedIn: 'root'
})
export class SubjectGradeCorrelationService {
  private BE_URL = environment.API_URL;

  constructor(private http: HttpClient) {
  }

  public getSubjectGradeCorrelation(correlationTreshold?: number, operator?: Operator): Observable<SubjectGradeCorrelation[]> {
    let params: HttpParams = new HttpParams();
    if (correlationTreshold && operator) {
      params = params.append('correlationTreshold', correlationTreshold).append('operator', operator);
    }
    return this.http.get<SubjectGradeCorrelation[]>(`${this.BE_URL}/subject-grade-correlation-controller/correlation`, {params});
  }
}
