import { Component, inject, Input } from '@angular/core';
import { MatCard, MatCardContent, MatCardHeader, MatCardTitle } from '@angular/material/card';
import { SubjectGradeCorrelation } from '../../types';
import { DecimalPipe } from '@angular/common';
import { Router } from '@angular/router';

@Component({
  selector: 'app-subject-grade-correlation-detail',
  standalone: true,
  imports: [MatCard, MatCardContent, MatCardHeader, MatCardTitle, DecimalPipe],
  templateUrl: './subject-grade-correlation-detail.component.html',
  styleUrl: './subject-grade-correlation-detail.component.scss',
})
export class SubjectGradeCorrelationDetailComponent {
  @Input() correlationData: SubjectGradeCorrelation | undefined;

  private readonly router = inject(Router);
  navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }
}
