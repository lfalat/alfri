import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { catchError, EMPTY, Observable } from 'rxjs';
import { DepartmentDto, SubjectDto, TeacherDto } from '../types';
import { NotificationService } from './notification.service';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class TeacherService {
  private readonly configService = inject(ConfigService);
  private readonly http = inject(HttpClient);
  private readonly notificationService = inject(NotificationService);

  private readonly BE_URL = `${this.configService.apiUrl()}`;

  getTeacherById(userId: number): Observable<TeacherDto> {
    return this.http.get<TeacherDto>(`${this.BE_URL}/teacher/${userId}`).pipe(
      catchError((error: HttpErrorResponse) => {
        this.notificationService.showError(error.error.message);
        return EMPTY;
      }),
    );
  }

  getTeacherSubjects(userId: number): Observable<SubjectDto[]> {
    return this.http
      .get<SubjectDto[]>(`${this.BE_URL}/teacher/${userId}/subjects`)
      .pipe(
        catchError((error: HttpErrorResponse) => {
          this.notificationService.showError(error.error.message);
          return EMPTY;
        }),
      );
  }

  getTeacherDepartment(userId: number): Observable<DepartmentDto> {
    return this.http
      .get<DepartmentDto>(`${this.BE_URL}/admin/teacher/${userId}/department`)
      .pipe(
        catchError((error: HttpErrorResponse) => {
          this.notificationService.showError(error.error.message);
          return EMPTY;
        }),
      );
  }

  updateTeacherSubjects(
    userId: number,
    subjectCodes: string[],
  ): Observable<TeacherDto> {
    return this.http.post<TeacherDto>(
      `${this.BE_URL}/admin/teacher/${userId}/subjects`,
      subjectCodes,
    );
  }

  updateTeacherDepartment(
    userId: number,
    departmentId: number | null | undefined,
  ): Observable<void> {
    return this.http.post<void>(
      `${this.BE_URL}/admin/teacher/${userId}/department`,
      { departmentId: departmentId },
    );
  }
}
