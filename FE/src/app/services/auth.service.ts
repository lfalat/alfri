import { inject, Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {
  ChangePasswordDto,
  RegisterUserDto,
  UserDto,
} from '../types';
import { ConfigService } from './config.service';
import { AuthRole } from '@enums/auth-role';
import { KeycloakService } from '@services/keycloak.service';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly configService = inject(ConfigService);
  private readonly keycloakService = inject(KeycloakService);

  private get URL() {
    return `${this.configService.apiUrl()}/auth`;
  }

  postUser(userData: RegisterUserDto): Observable<UserDto> {
    return throwError(() => new Error('User registration is handled by Keycloak.'));
  }

  logOut(): Promise<void> {
    return this.keycloakService.logout();
  }

  logIn(): Promise<void> {
    return this.keycloakService.login();
  }

  registerWithKeycloak(): Promise<void> {
    return this.keycloakService.register();
  }

  changePassword(passwordData: ChangePasswordDto): Observable<ChangePasswordDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };
    return this.http.post<ChangePasswordDto>(
      `${this.URL}/change-password`,
      passwordData,
      httpOptions,
    );
  }

  hasRole(expectedRoles: AuthRole | AuthRole[] | undefined): boolean {
    return this.keycloakService.hasRole(expectedRoles);
  }
}
