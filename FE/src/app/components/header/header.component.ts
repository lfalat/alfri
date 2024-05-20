import { Component } from '@angular/core';
import { AsyncPipe, NgClass, NgIf } from '@angular/common';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatIconModule } from '@angular/material/icon';
import { JwtService } from '../../services/jwt.service';
import { UserService } from '../../services/user.service';

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
  constructor(private userService: UserService) {
  }
  loggedIn() {
    return this.userService.loggedIn();
  }
}
