import { Component } from '@angular/core';
import { MatDrawer, MatDrawerContainer } from '@angular/material/sidenav';
import { MatButton } from '@angular/material/button';
import { NgOptimizedImage } from '@angular/common';
import { Router } from '@angular/router';
import { SpeechBubbleComponent } from '../components/speech-bubble/speech-bubble.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    MatDrawerContainer,
    MatButton,
    MatDrawer,
    NgOptimizedImage,
    SpeechBubbleComponent
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {

  constructor(private router: Router) {
  }
  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }
}
