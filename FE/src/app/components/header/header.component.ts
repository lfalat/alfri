import { Component, OnInit } from '@angular/core';
import { MatToolbar } from '@angular/material/toolbar';
import { UserService } from '../../services/user.service';
import { MatButton } from '@angular/material/button';
import { NgIf } from '@angular/common';
import { NavigationEnd, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [
    MatToolbar,
    MatButton,
    NgIf
  ],
  templateUrl: './header.component.html',
  styleUrl: './header.component.scss'
})
export class HeaderComponent implements OnInit {
  public isLoggedIn = false;

  constructor(private userService: UserService, private router: Router, private authService: AuthService) {
    this.isLoggedIn = this.userService.loggedIn();
  }

  ngOnInit() {
    this.router.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        this.isLoggedIn = this.userService.loggedIn();
      }
    });
  }

  logOut() {
    this.authService.logOut().then(() => {
      this.router.navigate(['login']);
    });
  }
}
