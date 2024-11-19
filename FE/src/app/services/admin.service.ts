import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Role, SubjectDto, UserDto } from '../types';

@Injectable({
  providedIn: 'root',
})
export class AdminService {
  private readonly BE_URL = `${environment.API_URL}`;

  constructor(private http: HttpClient) {}

  getAllUsers(): Observable<UserDto[]> {
    return this.http.get<UserDto[]>(`${this.BE_URL}/users`);
  }

  addUserRole(userId: number, role: Role): Observable<any> {
    return this.http.post(`${this.BE_URL}/users/${userId}/roles`, { roleId: role.id });
  }

  removeUserRole(userId: number, role: Role): Observable<any> {
    return this.http.delete(`${this.BE_URL}/users/${userId}/roles/${role.id}`);
  }

  deleteUser(userId: number): Observable<any> {
    return this.http.delete(`${this.BE_URL}/users/${userId}`);
  }

  getAllSubjects(): Observable<SubjectDto[]> {
    return this.http.get<SubjectDto[]>(`${this.BE_URL}/subjects`);
  }

  getTeacherSubjects(userId: number): Observable<SubjectDto[]> {
    return this.http.get<SubjectDto[]>(`${this.BE_URL}/teachers/${userId}/subjects`);
  }

  updateTeacherSubjects(teacherId: number, subjects: string[]): Observable<any> {
    return this.http.put(`${this.BE_URL}/teachers/${teacherId}/subjects`, { subjects });
  }
}
