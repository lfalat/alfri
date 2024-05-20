import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { StudyProgramDto } from '../types';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class StudentService {
  private readonly URL = 'http://localhost:8080/api/student';

  constructor(private http: HttpClient) {
  }

  public getStudyProgramOfCurrentUser(): Observable<StudyProgramDto> {
    return this.http.get<StudyProgramDto>(`${this.URL}/current/studyProgram`);
  }
}
