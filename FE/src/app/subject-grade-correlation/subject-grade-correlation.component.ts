import { Component, OnDestroy, OnInit } from '@angular/core';
import { SubjectGradeCorrelation } from '../types';
import { Observable, ReplaySubject } from 'rxjs';
import { SubjectGradeCorrelationService } from '../services/subject-grade-correlation.service';

@Component({
  selector: 'app-subject-grade-correlation',
  standalone: true,
  imports: [],
  templateUrl: './subject-grade-correlation.component.html',
  styleUrl: './subject-grade-correlation.component.scss'
})
export class SubjectGradeCorrelationComponent implements OnInit, OnDestroy {
  get getChartData$(): Observable<SubjectGradeCorrelation> {
    return this._getChartData$;
  }

  private _getChartData$: Observable<SubjectGradeCorrelation> = new Observable();
  private _destroy$: ReplaySubject<void> = new ReplaySubject(1);

  constructor(private subjectGradeCorrelationService: SubjectGradeCorrelationService) {
  }

  ngOnInit() {

  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }
}
