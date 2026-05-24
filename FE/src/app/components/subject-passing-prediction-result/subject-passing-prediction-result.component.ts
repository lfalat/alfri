import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { AsyncPipe, DecimalPipe, NgClass } from '@angular/common';
import { BehaviorSubject, Observable } from 'rxjs';
import { SubjectPassingPrediction } from '../../types';
import { MatCard, MatCardContent } from '@angular/material/card';

@Component({
  selector: 'app-subject-passing-prediction-result',
  standalone: true,
  imports: [MatIcon, AsyncPipe, DecimalPipe, NgClass, MatCard, MatCardContent],
  templateUrl: './subject-passing-prediction-result.component.html',
  styleUrl: './subject-passing-prediction-result.component.scss',
})
export class SubjectPassingPredictionResultComponent implements OnChanges {
  @Input() passingPrediction: SubjectPassingPrediction = {
    subjectName: '',
    passingProbability: 0,
    mark: '',
    recommendations: [],
  };

  private readonly passingPredictionSubject = new BehaviorSubject<SubjectPassingPrediction>(
    this.passingPrediction,
  );
  public passingPrediction$: Observable<SubjectPassingPrediction> =
    this.passingPredictionSubject.asObservable();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['passingPrediction']) {
      this.passingPredictionSubject.next(this.passingPrediction);
    }
  }

  public getProgressBarClass(percentage: number): string {
    if (percentage >= 80) {
      return 'progress-high';
    } else if (percentage >= 50) {
      return 'progress-medium';
    } else {
      return 'progress-low';
    }
  }

  getMarkClass(mark: string): string {
    switch (mark) {
      case 'A':
        return 'high-mark';
      case 'B':
      case 'C':
        return 'medium-mark';
      case 'D':
      case 'E':
        return 'low-mark';
      case 'Fx':
        return 'fail-mark';
      default:
        return '';
    }
  }
}
