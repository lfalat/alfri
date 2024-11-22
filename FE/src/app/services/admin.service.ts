import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { catchError, EMPTY, Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Role, SubjectDto, UserDto } from '../types';
import { NotificationService } from './notification-servie.service';

@Injectable({
  providedIn: 'root',
})
export class AdminService {
  private readonly BE_URL = `${environment.API_URL}`;

  constructor(private readonly http: HttpClient, private readonly notificationService: NotificationService) {
  }

  getAllUsers(): Observable<UserDto[]> {
    return this.http.get<UserDto[]>(`${this.BE_URL}/admin/users`);
  }

  updateUserRole(userId: number, role: Role, isAdd: boolean): Observable<any> {
    return this.http.post(`${this.BE_URL}/admin/user/${userId}/roles`, {
      roleIds: [role.id],
      add: isAdd
    });
  }

  deleteUser(userId: number): Observable<any> {
    return this.http.delete(`${this.BE_URL}/admin/user/${userId}`); //TODO a este prosim podavaj miesot any konkretne typy ak sa da
  }

  getAllSubjects(): Observable<SubjectDto[]> {
    return this.http.get<SubjectDto[]>(`${this.BE_URL}/subject/all`);
  }

  getTeacherSubjects(userId: number): Observable<SubjectDto[]> {
    return this.http.get<SubjectDto[]>(`${this.BE_URL}/teacher/${userId}/subjects`).pipe(catchError((error: HttpErrorResponse) => {
      this.notificationService.showError(error.error.message);
      return EMPTY;
    }));
  }

  updateTeacherSubjects(userId: number, subjectCodes: string[]): Observable<any> {
    return this.http.put(`${this.BE_URL}/teacher/${userId}/subjects`, { subjects: subjectCodes });
  }
}
