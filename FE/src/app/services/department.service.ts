import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { DepartmentDto } from '../types';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class DepartmentService {
  private readonly URL = `${environment.API_URL}/department`;

  constructor(private http: HttpClient) {}

  public getAllDepartments(): Observable<DepartmentDto[]> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.get<DepartmentDto[]>(this.URL, httpOptions);
  }
}
