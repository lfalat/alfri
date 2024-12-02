import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { MatProgressBar } from '@angular/material/progress-bar';
import { MatCard, MatCardSubtitle, MatCardTitle } from '@angular/material/card';
import { MatList, MatListItem, MatListItemIcon } from '@angular/material/list';
import { MatIcon } from '@angular/material/icon';
import { MatTooltip } from '@angular/material/tooltip';
import { MatLine, ThemePalette } from '@angular/material/core';
import { AsyncPipe, NgClass, NgForOf, NgIf } from '@angular/common';
import { BehaviorSubject, Observable } from 'rxjs';
import { SubjectPassingPrediction } from '../../types';

@Component({
  selector: 'app-subject-passing-prediction-result',
  standalone: true,
  imports: [
    MatProgressBar,
    MatCard,
    MatCardTitle,
    MatCardSubtitle,
    MatList,
    MatListItem,
    MatIcon,
    MatTooltip,
    MatListItemIcon,
    MatLine,
    NgForOf,
    AsyncPipe,
    NgIf,
    NgClass
  ],
  templateUrl: './subject-passing-prediction-result.component.html',
  styleUrl: './subject-passing-prediction-result.component.scss'
})
export class SubjectPassingPredictionResultComponent implements OnChanges{
  @Input() passingPrediction: SubjectPassingPrediction = {
    subjectName: '',
    subjectCode: '',
    passingProbability: 0,
    mark: '',
    recommendations: []
  };

  private readonly passingPredictionSubject = new BehaviorSubject<SubjectPassingPrediction>(this.passingPrediction);
  public passingPrediction$: Observable<SubjectPassingPrediction> = this.passingPredictionSubject.asObservable();

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['passingPrediction']) {
      this.passingPredictionSubject.next(this.passingPrediction);
    }
  }

  public getProgressColor(percentage: number): ThemePalette {
    if (percentage >= 80) {
      return 'primary';
    } else if (percentage >= 50) {
      return 'accent';
    } else {
      return 'warn';
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
