import { Component, OnInit } from '@angular/core';
import { MatButton } from '@angular/material/button';
import { NgIf, NgOptimizedImage } from '@angular/common';
import { UserFormResultsComponent } from '@components/user-form-results/user-form-results.component';
import { USER_FORM_ID } from '../home.component';
import { Router } from '@angular/router';
import { FormService } from '@services/form.service';
import { AnsweredForm } from '../../../types';

@Component({
  selector: 'app-user-home',
  standalone: true,
  imports: [MatButton, NgIf, NgOptimizedImage, UserFormResultsComponent],
  templateUrl: './user-home.component.html',
  styleUrl: './user-home.component.scss',
})
export class UserHomeComponent implements OnInit {
  hasUserFilledForm = false;
  formData: AnsweredForm | undefined;

  constructor(
    private router: Router,
    private formService: FormService,
  ) {}

  ngOnInit() {
    this.formService.getExistingFormAnswers(USER_FORM_ID).subscribe({
      next: (data: AnsweredForm) => {
        this.formData = data;
        this.hasUserFilledForm = true;
      },
      error: () => {
        this.hasUserFilledForm = false;
      },
    });
  }

  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }
}
