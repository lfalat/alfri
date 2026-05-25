import { HttpClient, HttpHeaders } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { StudyProgramDto } from '../types';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class StudyProgramService {
  private readonly http = inject(HttpClient);
  private readonly config = inject(ConfigService);
  private readonly URL = `${this.config.apiUrl()}/studyProgram`;

  public getAll(): Observable<StudyProgramDto[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<StudyProgramDto[]>(this.URL, httpOptions);
  }
}
