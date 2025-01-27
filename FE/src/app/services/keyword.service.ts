import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { SubjectExtendedDto } from '../types';

@Injectable({
  providedIn: 'root',
})
export class KeywordService {
  private readonly URL = `${environment.API_URL}/keyword`;

  constructor(private http: HttpClient) {}

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
