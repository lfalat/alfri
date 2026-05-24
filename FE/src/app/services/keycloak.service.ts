import { inject, Injectable, signal } from '@angular/core';
import { KeycloakService as AngularKeycloakService } from 'keycloak-angular';
import { ConfigService } from '@services/config.service';
import { AuthRole } from '@enums/auth-role';

@Injectable({
  providedIn: 'root',
})
export class KeycloakService {
  private readonly configService = inject(ConfigService);
  private readonly keycloak = inject(AngularKeycloakService);
  private readonly authenticatedSignal = signal(false);

  readonly authenticated = this.authenticatedSignal.asReadonly();

  async initialize(): Promise<void> {
    const authenticated = await this.keycloak.init({
      config: {
        url: this.keycloakUrl,
        realm: this.realm,
        clientId: this.clientId,
      },
      initOptions: {
        onLoad: 'check-sso',
        pkceMethod: 'S256',
        checkLoginIframe: false,
      },
      enableBearerInterceptor: false,
      loadUserProfileAtStartUp: false,
    });

    this.authenticatedSignal.set(authenticated);
  }

  isAuthenticated(): boolean {
    return this.keycloak.isLoggedIn();
  }

  async login(redirectPath = '/home'): Promise<void> {
    await this.keycloak.login({
      redirectUri: this.redirectUri(redirectPath),
    });
  }

  async register(redirectPath = '/home'): Promise<void> {
    await this.keycloak.register({
      redirectUri: this.redirectUri(redirectPath),
    });
  }

  async logout(): Promise<void> {
    this.authenticatedSignal.set(false);
    await this.keycloak.logout(`${window.location.origin}/login`);
  }

  async getToken(): Promise<string | null> {
    if (!this.isAuthenticated()) {
      this.authenticatedSignal.set(false);
      return null;
    }

    try {
      await this.keycloak.updateToken(30);
      this.authenticatedSignal.set(true);
      return this.keycloak.getToken();
    } catch {
      this.keycloak.clearToken();
      this.authenticatedSignal.set(false);
      return null;
    }
  }

  hasRole(expectedRoles: AuthRole | AuthRole[] | undefined): boolean {
    if (!expectedRoles || !this.isAuthenticated()) {
      return false;
    }

    const normalizedExpectedRoles = Array.isArray(expectedRoles) ? expectedRoles : [expectedRoles];
    const userRoles = this.getUserRoles();

    return userRoles.some((role) => normalizedExpectedRoles.includes(role as AuthRole));
  }

  private getUserRoles(): string[] {
    const roles = this.keycloak.getUserRoles(true);
    return roles.map((role) => (role.startsWith('ROLE_') ? role : `ROLE_${role.toUpperCase()}`));
  }

  private get keycloakUrl(): string {
    const keycloakUrl = this.configService.keycloakUrl();
    if (!keycloakUrl) {
      throw new Error('Missing KEYCLOAK_URL runtime config');
    }
    return keycloakUrl.replace(/\/$/, '');
  }

  private get realm(): string {
    const realm = this.configService.keycloakRealm();
    if (!realm) {
      throw new Error('Missing KEYCLOAK_REALM runtime config');
    }
    return realm;
  }

  private get clientId(): string {
    const clientId = this.configService.keycloakClientId();
    if (!clientId) {
      throw new Error('Missing KEYCLOAK_CLIENT_ID runtime config');
    }
    return clientId;
  }

  private redirectUri(path: string): string {
    return new URL(path, window.location.origin).toString();
  }
}
