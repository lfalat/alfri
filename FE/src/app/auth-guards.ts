import { inject, Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivateFn, Router, RouterStateSnapshot } from '@angular/router';
import { UserService } from '@services/user.service';
import { AuthService } from '@services/auth.service';

/**
 * Basic JWT token auth guard
 */
export const tokenAppGuard: CanActivateFn = (): boolean => {
  const router = inject(Router);
  const userService = inject(UserService);

  if (!userService.loggedIn()) {
    router.navigate(['/login']);
    return false;
  }

  return true;
};

/**
 * Role based auth guard
 */
export const roleAppGuard: CanActivateFn = (route: ActivatedRouteSnapshot, state: RouterStateSnapshot) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  const expectedRole = route.data['role'];

  if (authService.hasRole(expectedRole)) {
    return true;
  }

  router.navigate(['404']);
  return false;
};

@Injectable({
  providedIn: 'root',
})
export class AuthGuards {
  constructor(
    private userService: UserService,
    private router: Router,
  ) {}

  canActivate(): boolean {
    if (!this.userService.loggedIn()) {
      this.router.navigate(['login']);
      return false;
    }

    return true;
  }
}
