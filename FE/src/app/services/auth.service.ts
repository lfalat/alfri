import { Injectable } from '@angular/core';
import { Observable, tap } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthResponseDto, AuthRole, ChangePasswordDto, LoginUserDto, RegisterUserDto, UserDto } from '../types';
import { JwtService } from './jwt.service';
import { environment } from '../../environments/environment';
import { UserService } from './user.service';
import { JwtHelperService } from '@auth0/angular-jwt';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly URL = `${environment.API_URL}/auth`;

  constructor(
    private http: HttpClient,
    private jwtService: JwtService,
    private userService: UserService,
    private jwtHelper: JwtHelperService) {
  }

  postUser(userData: RegisterUserDto): Observable<UserDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post<UserDto>(`${this.URL}/register`, userData, httpOptions);
  }

  authenticate(userData: LoginUserDto): Observable<AuthResponseDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post<AuthResponseDto>(`${this.URL}/authenticate`, userData, httpOptions).pipe(tap(() => {
      this.userService.loadUserData();
    }));
  }

  logOut(): Promise<void> {
    return new Promise((resolve, _) => {
      this.jwtService.removeToken();
      resolve();
    });
  }

  changePassword(passwordData: ChangePasswordDto): Observable<ChangePasswordDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };
    return this.http.post<ChangePasswordDto>(`${this.URL}/change-password`, passwordData, httpOptions);
  }

  hasRole(expectedRole: AuthRole | undefined): boolean {
    if (!expectedRole) {
      return false;
    }

    const userRoles = this.jwtHelper.decodeToken()?.roles;

    if (!userRoles) {
      return false;
    }

    console.log(expectedRole, userRoles);

    return userRoles.includes(expectedRole);
  }
}
