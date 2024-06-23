import { Injectable } from '@angular/core';
import { JwtHelperService } from '@auth0/angular-jwt';
import { HttpClient } from '@angular/common/http';
import type { Observable } from 'rxjs';
import { UserDto } from '../types';
import { environment } from '../../environments/environment';


@Injectable({
  providedIn: 'root'
})
export class UserService {
  public userId: number | undefined;
  private readonly URL = `${environment.API_URL}/user`;

  constructor(private http: HttpClient, public jwtHelper: JwtHelperService) {
  }

  saveUserId(userId: number) {
    this.userId = userId;
  }

  loggedIn() {
    return !this.jwtHelper.isTokenExpired();
  }

  getUserInfo(): Observable<UserDto> {
    return this.http.get<UserDto>(`${URL}/profile`);
  }
}
