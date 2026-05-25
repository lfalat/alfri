import { inject, Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, take } from 'rxjs';
import { Role, UserDtoExtended } from '../types';
import { ConfigService } from '@services/config.service';
import { KeycloakService } from '@services/keycloak.service';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  readonly userData = signal<UserDtoExtended | null>(null);

  userId: number | undefined;
  private readonly configService = inject(ConfigService);
  private readonly BE_URL = `${this.configService.apiUrl()}/user`;

  private readonly http = inject(HttpClient);
  private readonly keycloakService = inject(KeycloakService);

  public loadUserData() {
    // Check if data already exists
    if (this.userData()) {
      return;
    }

    this.loadUserInfo()
      .pipe(take(1))
      .subscribe({
        next: (userData) => {
          this.userData.set(userData);
        },
        error: () => {
          this.userData.set(null);
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
    return this.keycloakService.isAuthenticated();
  };

  loadUserInfo(): Observable<UserDtoExtended> {
    return this.http.get<UserDtoExtended>(`${this.BE_URL}/profile`);
  }

  public getRoles(): Observable<Role[]> {
    return this.http.get<Role[]>(`${this.BE_URL}/roles`);
  }
}
