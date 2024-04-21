import { Injectable } from '@angular/core';
import type { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { AuthResponseDto, LoginUserDto, RegisterUserDto, UserDto } from '../types';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  url = 'http://localhost:8080/api/auth';

  constructor(private http: HttpClient) {
  }

  postUser(userData: RegisterUserDto): Observable<UserDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post<UserDto>(`${this.url}/register`, userData, httpOptions);
  }

  authenticate(userData: LoginUserDto): Observable<AuthResponseDto> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'application/json'
      })
    };

    return this.http.post<AuthResponseDto>(`${this.url}/authenticate`, userData, httpOptions);
  }
}
