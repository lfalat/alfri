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

  constructor(
    private readonly http: HttpClient,
  ) {}

  getAllUsers(): Observable<UserDto[]> {
    return this.http.get<UserDto[]>(`${this.BE_URL}/admin/users`);
  }

  updateUserRole(userId: number, role: Role, isAdd: boolean): Observable<any> {
    return this.http.post(`${this.BE_URL}/admin/user/${userId}/roles`, {
      roleIds: [role.id],
      add: isAdd,
    });
  }

  deleteUser(userId: number): Observable<void> {
    return this.http.delete<void>(`${this.BE_URL}/admin/user/${userId}`);
  }

  getAllSubjects(): Observable<SubjectDto[]> {
    return this.http.get<SubjectDto[]>(`${this.BE_URL}/subject/all`);
  }

  // getTeacherSubjects(userId: number): Observable<SubjectDto[]> {
  //   return this.http.get<SubjectDto[]>(`${this.BE_URL}/teacher/${userId}/subjects`).pipe(catchError((error: HttpErrorResponse) => {
  //     this.notificationService.showError(error.error.message);
  //     return EMPTY;
  //   }));
  // }
  //
  // updateTeacherSubjects(userId: number, subjectCodes: string[]): Observable<void> {
  //   return this.http.put<void>(`${this.BE_URL}/teacher/${userId}/subjects`, { subjectCodes });
  // }
}
