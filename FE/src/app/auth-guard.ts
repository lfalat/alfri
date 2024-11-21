import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from './services/user.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard {
  constructor(private userService: UserService, private router: Router) {}

  canActivate(): boolean {
    if (!this.userService.loggedIn()) {
      this.router.navigate(['login']);
      return false;
    }

    return true;
  }
}
