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
import { AuthRole, UserDto } from '../../types';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { HasRoleDirective } from '../../directives/auth.directive';

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
    MatExpansionPanelHeader,
    HasRoleDirective,
  ],
})
export class HeaderComponent {
  protected readonly AuthRole = AuthRole;
  userData: UserDto | undefined;

  get isUserStudent(): boolean {
    return (
      this.userData?.roles
        .map((role) => role.name)
        .includes(this.AuthRole.STUDENT) ?? false
    );
  }

  get isUserTeacher(): boolean {
    return (
      this.userData?.roles
        .map((role) => role.name)
        .includes(this.AuthRole.TEACHER) ?? false
    );
  }

  get isUserAdmin(): boolean {
    return (
      this.userData?.roles.map((role) => role.name).includes(this.AuthRole.ADMIN) ??
      false
    );
  }

  constructor(
    private readonly userService: UserService,
    private readonly authService: AuthService,
    private readonly router: Router,
  ) {
    this.userService.userData
      .pipe(takeUntilDestroyed())
      .subscribe((userData: UserDto) => {
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
