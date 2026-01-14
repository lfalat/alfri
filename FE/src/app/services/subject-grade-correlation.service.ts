import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { SubjectGradeCorrelation } from '../types';
import { Operator } from '@enums/operator';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class SubjectGradeCorrelationService {
  private readonly config = inject(ConfigService);
  private readonly BE_URL = this.config.apiUrl();
  private readonly http = inject(HttpClient);

  public getSubjectGradeCorrelation(
    correlationTreshold?: number,
    operator?: Operator,
  ): Observable<SubjectGradeCorrelation[]> {
    let params: HttpParams = new HttpParams();
    if (correlationTreshold && operator) {
      params = params
        .append('correlationTreshold', correlationTreshold)
        .append('operator', operator);
    }
    return this.http.get<SubjectGradeCorrelation[]>(
      `${this.BE_URL}/subject-grade-correlation-controller/correlation`,
      { params },
    );
  }
}
