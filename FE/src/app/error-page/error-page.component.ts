import { Component } from '@angular/core';
import { MatCard } from '@angular/material/card';

@Component({
  selector: 'app-error-page',
  standalone: true,
  imports: [
    MatCard
  ],
  templateUrl: './error-page.component.html',
  styleUrl: './error-page.component.scss'
})
export class ErrorPageComponent {

}
