import { Component, computed, inject, signal, ViewChild } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatSidenav, MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatIconModule } from '@angular/material/icon';
import { UserService } from '@services/user.service';
import { AuthService } from '@services/auth.service';
import { NavigationEnd, Router } from '@angular/router';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';
import {
  MatExpansionPanel,
  MatExpansionPanelHeader,
  MatExpansionPanelTitle,
} from '@angular/material/expansion';
import { HasRoleDirective } from '@directives/auth.directive';
import { AuthRole } from '@enums/auth-role';
import { NotificationService } from '@services/notification.service';
import { filter } from 'rxjs';
import { FormDataService } from '@services/form-data.service';
import { toSignal } from '@angular/core/rxjs-interop';
import { MatCard } from '@angular/material/card';

interface MenuItem {
  label: string;
  icon: string;
  route: string;
  action?: () => void;
}

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
    MatMenu,
    MatMenuItem,
    MatMenuTrigger,
    MatExpansionPanel,
    MatExpansionPanelTitle,
    MatExpansionPanelHeader,
    HasRoleDirective,
    MatCard,
  ],
})
export class HeaderComponent {
  readonly AuthRole = AuthRole;
  @ViewChild('drawer') drawer!: MatSidenav;

  readonly userService = inject(UserService);
  protected readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  private readonly notificationService = inject(NotificationService);
  private readonly formDataService = inject(FormDataService);

  // Signals
  readonly formData = toSignal(this.formDataService.formData$);
  readonly loggedIn = this.userService.loggedIn;
  readonly currentRoute = signal<string>('');

  // Computed signals
  readonly canAccessSubjects = computed(() => !!this.formData());

  readonly canAccessReports = computed(() => {
    const output = this.authService.hasRole([AuthRole.VEDENIE, AuthRole.ADMIN, AuthRole.TEACHER]);

    console.log(output);
    return output;
  });

  readonly userInitials = computed(() => {
    const userData = this.userService.userData();
    if (!userData) return '';
    const firstInitial = userData.firstName.at(0)?.toUpperCase() ?? '';
    const lastInitial = userData.lastName.at(0)?.toUpperCase() ?? '';
    return firstInitial + lastInitial;
  });

  readonly userFullName = computed(() => {
    const userData = this.userService.userData();
    if (!userData) {
      return '';
    }

    return `${userData.firstName} ${userData.lastName}`;
  });

  readonly userRole = computed(() => {
    const userData = this.userService.userData();
    if (!userData?.roles?.length) return '';
    // Get the first role name or map to a display name
    const role = userData.roles[0].name;
    const roleMap: Record<string, string> = {
      ADMIN: 'Administrátor',
      TEACHER: 'Učiteľ',
      VEDENIE: 'Vedenie',
      STUDENT: 'Študent',
    };
    return roleMap[role] || role;
  });

  // Menu configuration
  readonly subjectMenuItems: MenuItem[] = [
    { label: 'Prehľad predmetov', icon: 'list_view', route: 'subjects' },
    { label: 'Zaujímavé predmety', icon: 'interests', route: 'recommendation' },
    { label: 'Podobné predmety', icon: 'bubble_chart', route: 'clustering' },
    {
      label: 'Predikcia absolvovania',
      icon: 'check_circle',
      route: 'passing-prediction',
    },
  ];

  readonly reportMenuItems: MenuItem[] = [
    {
      label: 'Predmety podľa známok',
      icon: 'summarize',
      route: 'subject-reports',
    },
    {
      label: 'Korelačná analýza známok',
      icon: 'query_stats',
      route: 'subjects-grades-correlation',
    },
    { label: 'Kľúčové slová', icon: 'vpn_key', route: 'keywords' },
  ];

  readonly userMenuItems: MenuItem[] = [
    { label: 'Profil', icon: 'account_circle', route: 'profile' },
    {
      label: 'Odhlásiť sa',
      icon: 'logout',
      route: '',
      action: () => this.logOut(),
    },
  ];

  constructor() {
    // Load user data if logged in
    if (this.loggedIn()) {
      this.userService.loadUserData();
    }

    // Fetch form data on init
    this.formDataService.fetchFormData();

    // Track current route
    this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe((event: NavigationEnd) => {
        const route = event.urlAfterRedirects.split('/')[1] || '';
        this.currentRoute.set(route);
        if (this.drawer?.opened) {
          this.drawer.close();
        }
      });

    // Set initial route
    const initialRoute = this.router.url.split('/')[1] || '';
    this.currentRoute.set(initialRoute);
  }

  logOut() {
    this.authService.logOut().then(() => {
      this.router.navigate(['login']);
    });
  }

  navigate(route: string) {
    this.router.navigate([route]);
  }

  navigateToHome() {
    this.router.navigate(['home']);
  }

  navigateToAdminPage() {
    this.router.navigate(['admin-page']);
  }

  openDrawer() {
    this.drawer.toggle();
    this.notificationService.hideSnackbar();
  }

  handleMenuItemClick(item: MenuItem) {
    if (item.action) {
      item.action();
    } else {
      this.navigate(item.route);
    }
  }

  isMenuItemSelected(route: string): boolean {
    return this.currentRoute() === route;
  }
}
