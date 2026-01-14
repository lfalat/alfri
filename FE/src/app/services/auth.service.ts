import { inject, Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {
  AuthResponseDto,
  ChangePasswordDto,
  LoginUserDto,
  RegisterUserDto,
  UserDto,
} from '../types';
import { JwtService } from './jwt.service';
import { ConfigService } from './config.service';
import { JwtHelperService } from '@auth0/angular-jwt';
import { AuthRole } from '@enums/auth-role';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly jwtService = inject(JwtService);
  private readonly jwtHelper = inject(JwtHelperService);
  private readonly configService = inject(ConfigService);

  private get URL() {
    return `${this.configService.apiUrl()}/auth`;
  }

  postUser(userData: RegisterUserDto): Observable<UserDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.post<UserDto>(
      `${this.URL}/register`,
      userData,
      httpOptions,
    );
  }

  authenticate(userData: LoginUserDto): Observable<AuthResponseDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json',
      }),
    };

    return this.http.post<AuthResponseDto>(
      `${this.URL}/authenticate`,
      userData,
      httpOptions,
    );
  }

  logOut(): Promise<void> {
    return new Promise((resolve) => {
      this.jwtService.removeToken();
      resolve();
    });
  }

  changePassword(
    passwordData: ChangePasswordDto,
  ): Observable<ChangePasswordDto> {
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

  hasRole(expectedRoles: AuthRole[] | undefined): boolean {
    if (!expectedRoles) {
      return false;
    }

    const userRoles = this.jwtHelper.decodeToken()?.roles;
    console.log(userRoles);

    if (!userRoles) {
      return false;
    }

    return userRoles.some((role: AuthRole) => expectedRoles.includes(role));
  }
}
