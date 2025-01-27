import { Component} from '@angular/core';
import { NavigationEnd, Router, RouterOutlet } from '@angular/router';
import { MatToolbar } from '@angular/material/toolbar';
import { FooterComponent } from '@components/footer/footer.component';
import { NgIf } from '@angular/common';
import { HeaderComponent } from '@components/header/header.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, MatToolbar, FooterComponent, NgIf, HeaderComponent],
  templateUrl: './app.component.html',
})
export class AppComponent {
  title = 'Alfri';
  public showFooter = false;
  noFooterRoutes = ['login', 'register', '404'];

  constructor(private router: Router) {
    this.router.events.subscribe((event) => {
      if (event instanceof NavigationEnd) {
        this.showFooter = !this.noFooterRoutes.includes(
          event.url.split('/')[1],
        );
      }
    });
  }
}
