import { inject, Injectable, signal } from '@angular/core';
import { JwtHelperService } from '@auth0/angular-jwt';
import { HttpClient } from '@angular/common/http';
import { Observable, take } from 'rxjs';
import { Role, UserDto } from '../types';
import { ConfigService } from '@services/config.service';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  readonly userData = signal<UserDto | undefined>(undefined);

  userId: number | undefined;
  private readonly configService = inject(ConfigService);
  private readonly BE_URL = `${this.configService.apiUrl()}/user`;

  private readonly http = inject(HttpClient);
  public readonly jwtHelper = inject(JwtHelperService);

  public loadUserData() {
    // Check if data already exists
    if (this.userData()) {
      return;
    }

    this.loadUserInfo()
      .pipe(take(1))
      .subscribe({
        next: (userData: UserDto) => {
          this.userData.set(userData);
        },
        error: () => {
          this.userData.set(undefined);
        },
      });
  }

  saveUserId(userId: number) {
    this.userId = userId;
  }

  /**
   * Checks if user is logged in by verifying token existence and expiration.
   * Note: This is a client-side check only. Token signature validity is verified
   * server-side on each API request. If the token is invalid (e.g., signing key changed),
   * the server will return 401 and the token should be cleared via error handling.
   */
  loggedIn = () => {
    try {
      const token = this.jwtHelper.tokenGetter();

      // Handle promise-based token getter
      if (token instanceof Promise) {
        // Can't reliably check async tokens synchronously
        // Fall back to checking localStorage directly
        const syncToken = localStorage.getItem('access_token');
        if (!syncToken) {
          return false;
        }
        return !this.jwtHelper.isTokenExpired(syncToken);
      }

      // No token means not logged in
      if (!token) {
        return false;
      }

      // Check if token is expired
      return !this.jwtHelper.isTokenExpired(token);
    } catch (error) {
      // If token is malformed or invalid, consider not logged in
      console.error('Invalid token format:', error);
      return false;
    }
  };

  loadUserInfo(): Observable<UserDto> {
    return this.http.get<UserDto>(`${this.BE_URL}/profile`);
  }

  public getRoles(): Observable<Role[]> {
    return this.http.get<Role[]>(`${this.BE_URL}/roles`);
  }
}
