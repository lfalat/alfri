import { inject, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { StudyProgramDto } from '../types';
import { Observable } from 'rxjs';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class StudentService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/student`;

  public getStudyProgramOfCurrentUser(): Observable<StudyProgramDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<StudyProgramDto>(
      `${this.URL}/current/studyProgram`,
      httpOptions,
    );
  }
}
