import { Injectable } from '@angular/core';
import { Observable, tap } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { AuthResponseDto, ChangePasswordDto, LoginUserDto, RegisterUserDto, UserDto } from '../types';
import { JwtService } from './jwt.service';
import { environment } from '../../environments/environment';
import { UserService } from './user.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly URL = `${environment.API_URL}/auth`;

  constructor(private readonly http: HttpClient, private readonly jwtService: JwtService, private readonly userService: UserService) {
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
}
