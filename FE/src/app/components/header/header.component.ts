import { Component } from '@angular/core';
import { AsyncPipe, NgClass, NgIf } from '@angular/common';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatIconModule } from '@angular/material/icon';
import { UserService } from '../../services/user.service';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrl: './header.component.scss',
  standalone: true,
  imports: [
    MatToolbarModule,
    MatButtonModule,
    MatSidenavModule,
    MatListModule,
    MatIconModule,
    AsyncPipe,
    NgClass,
    NgIf,
  ]
})
export class HeaderComponent {
  constructor(private userService: UserService, private authService: AuthService, private router: Router) {
  }

  loggedIn() {
    return this.userService.loggedIn();
  }

  logOut() {
    this.authService.logOut().then(() => {
      this.router.navigate(['login']);
    });
  }

  navigateToSubjects() {
    this.router.navigate(['subjects']);
  }

  navigateToPrediction() {
    this.router.navigate(['recommendation']);
  }

  navigateToProfile() {
    this.router.navigate(['profile']);
  }
}
