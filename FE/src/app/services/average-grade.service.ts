import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AverageGradeDto } from '../types';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AverageGradeService {

  private BE_URL = environment.API_URL;

  constructor(private http: HttpClient) {}

  getAverageGradesByProgram(program: string): Observable<AverageGradeDto[]> {
    return this.http.get<AverageGradeDto[]>(`${this.BE_URL}/average-grades?program=${program}`);
  }
}
