import { inject, Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanActivateFn,
  Router,
  RouterStateSnapshot,
} from '@angular/router';
import { UserService } from '@services/user.service';
import { AuthService } from '@services/auth.service';
import { AuthRole } from '@enums/auth-role';
import { KeycloakService } from '@services/keycloak.service';

export const tokenAppGuard: CanActivateFn = (
  _route: ActivatedRouteSnapshot,
  state: RouterStateSnapshot,
): boolean => {
  const userService = inject(UserService);
  const keycloakService = inject(KeycloakService);

  if (!userService.loggedIn()) {
    keycloakService.login(state.url);
    return false;
  }

  return true;
};

/**
 * Role based auth guard
 */
export const roleAppGuard: CanActivateFn = (route: ActivatedRouteSnapshot) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  const expectedRoles: AuthRole[] = route.data['role'];

  if (authService.hasRole(expectedRoles)) {
    return true;
  }

  router.navigate(['404']);
  return false;
};

@Injectable({
  providedIn: 'root',
})
export class AuthGuards {
  private readonly userService = inject(UserService);
  private readonly keycloakService = inject(KeycloakService);

  canActivate(redirectPath = '/home'): boolean {
    if (!this.userService.loggedIn()) {
      void this.keycloakService.login(redirectPath);
      return false;
    }

    return true;
  }
}
