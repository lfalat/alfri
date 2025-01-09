import { Component, OnInit } from '@angular/core';
import { MatDrawer, MatDrawerContainer } from '@angular/material/sidenav';
import { MatButton } from '@angular/material/button';
import { NgIf, NgOptimizedImage } from '@angular/common';
import { Router } from '@angular/router';
import { SpeechBubbleComponent } from '../components/speech-bubble/speech-bubble.component';
import { ReactiveFormsModule } from '@angular/forms';
import { FormService } from '../services/form.service';
import { CdkDrag } from '@angular/cdk/drag-drop';

export const USER_FORM_ID = 69;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [
    MatDrawerContainer,
    MatButton,
    MatDrawer,
    NgOptimizedImage,
    SpeechBubbleComponent,
    ReactiveFormsModule,
    NgIf,
    CdkDrag
  ],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent implements OnInit {
  hasUserFilledForm = false;

  constructor(private router: Router, private formService: FormService) {
  }

  ngOnInit() {
    this.formService.hasUserFilledForm(USER_FORM_ID).subscribe({
      next: () => {
        this.hasUserFilledForm = true;
      }
    });
  }


  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }
}
