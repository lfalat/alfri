import { Injectable } from '@angular/core';
import { JwtHelperService } from '@auth0/angular-jwt';
import { HttpClient } from '@angular/common/http';
import { Observable, ReplaySubject, take } from 'rxjs';
import { Role, UserDto } from '../types';
import { environment } from '../../environments/environment';


@Injectable({
  providedIn: 'root'
})
export class UserService {
  get userData(): Observable<UserDto> {
    return this._userData.asObservable();
  }

  public userId: number | undefined;

  private readonly _userData: ReplaySubject<UserDto> = new ReplaySubject(1);
  private readonly BE_URL = `${environment.API_URL}/user`;

  constructor(private readonly http: HttpClient, public jwtHelper: JwtHelperService) {}

  public loadUserData() {
    this.loadUserInfo().pipe(take(1)).subscribe((userData: UserDto) => {
      console.log(userData);
      this._userData.next(userData);
    });
  }

  saveUserId(userId: number) {
    this.userId = userId;
  }

  loggedIn() {
    return !this.jwtHelper.isTokenExpired();
  }

  loadUserInfo(): Observable<UserDto> {
    return this.http.get<UserDto>(`${this.BE_URL}/profile`);
  }

  public getRoles(): Observable<Role[]> {
    return this.http.get<Role[]>(`${this.BE_URL}/roles`);
  }
}
