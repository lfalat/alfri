import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { StudyProgramDto } from '../types';

@Injectable({
  providedIn: 'root',
})
export class StudyProgramService {
  private readonly URL = 'http://localhost:8080/api/studyProgram';

  constructor(private http: HttpClient) {
  }

  public getAll(): Observable<StudyProgramDto[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.get<StudyProgramDto[]>(this.URL, httpOptions);
  }
}
