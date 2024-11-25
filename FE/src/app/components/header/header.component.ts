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
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';
import { MatExpansionPanel, MatExpansionPanelHeader, MatExpansionPanelTitle } from '@angular/material/expansion';
import { UserDto } from '../../types';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

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
    MatMenu,
    MatMenuItem,
    MatMenuTrigger,
    MatExpansionPanel,
    MatExpansionPanelTitle,
    MatExpansionPanelHeader
  ]
})
export class HeaderComponent {
  private userData: UserDto | undefined;

  private readonly ROLE_STUDENT = 'ROLE_STUDENT';
  private readonly ROLE_TEACHER = 'ROLE_TEACHER';
  private readonly ROLE_ADMIN = 'ROLE_ADMIN';

  get isUserStudent(): boolean {
    return this.userData?.roles.map((role) => role.name).includes(this.ROLE_STUDENT) ?? false;
  }

  get isUserTeacher(): boolean {
    return this.userData?.roles.map((role) => role.name).includes(this.ROLE_TEACHER) ?? false;
  }

  get isUserAdmin(): boolean {
    return this.userData?.roles.map((role) => role.name).includes(this.ROLE_ADMIN) ?? false;
  }

  constructor(private readonly userService: UserService, private readonly authService: AuthService, private readonly router: Router) {
    this.userService.userData.pipe(takeUntilDestroyed()).subscribe((userData: UserDto) => {
      this.userData = userData;
    });
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

  navigateToHome() {
    this.router.navigate(['home']);
  }

  navigateToSubjectChances() {
    this.router.navigate(['subjects-chance']);
  }

  public navigateToSubjectsClustering() {
    this.router.navigate(['clustering']);
  }

  navigateToPassingPrediction() {
    this.router.navigate(['passing-prediction']);
  }

  navigateToSubjectsReports() {
    this.router.navigate(['subject-reports']);
  }

  navigateToSubjectGradeCorrelation() {
    this.router.navigate(['subjects-grades-correlation']);
  }

  navigateToAdminPage() {
    this.router.navigate(['admin-page']);
  }
}
