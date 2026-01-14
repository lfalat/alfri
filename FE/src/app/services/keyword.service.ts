import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { SubjectExtendedDto } from '../types';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class KeywordService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/keyword`;

  public searchKeywords(value: string): Observable<string[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<string[]>(`${this.URL}/search/${value}`, httpOptions);
  }

  public showSubjects(keyword: string): Observable<SubjectExtendedDto[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<SubjectExtendedDto[]>(
      `${this.URL}/${keyword}/subjects`,
      httpOptions,
    );
  }
}
