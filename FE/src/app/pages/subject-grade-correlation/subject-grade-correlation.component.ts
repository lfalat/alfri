import { Component, OnDestroy, OnInit } from '@angular/core';
import {
  BehaviorSubject,
  forkJoin,
  map,
  Observable,
  of,
  ReplaySubject,
  switchMap,
  takeUntil,
} from 'rxjs';
import { SubjectGradeCorrelationService } from '@services/subject-grade-correlation.service';
import { NgApexchartsModule } from 'ng-apexcharts';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { MatInput } from '@angular/material/input';
import { FormsModule } from '@angular/forms';
import { MatCheckbox } from '@angular/material/checkbox';
import {
  MatTab,
  MatTabChangeEvent,
  MatTabGroup,
  MatTabLabel,
} from '@angular/material/tabs';
import { Operator } from '@enums/operator';
import { AsyncPipe } from '@angular/common';
import { SubjectGradeCorrelationDetailComponent } from '@components/subject-grade-correlation-detail/subject-grade-correlation-detail.component';
import { MatIcon } from '@angular/material/icon';
import { ApexChartOptions, SubjectGradeCorrelation } from '../../types';

@Component({
  selector: 'app-subject-grade-correlation',
  standalone: true,
  imports: [
    NgApexchartsModule,
    MatProgressSpinner,
    MatInput,
    FormsModule,
    MatCheckbox,
    MatTabGroup,
    MatTab,
    AsyncPipe,
    SubjectGradeCorrelationDetailComponent,
    MatIcon,
    MatTabLabel,
  ],
  templateUrl: './subject-grade-correlation.component.html',
  styleUrls: ['./subject-grade-correlation.component.scss'],
})
export class SubjectGradeCorrelationComponent implements OnInit, OnDestroy {
  get chartOptions(): ApexChartOptions {
    return this._chartOptions;
  }

  get heatmapDataLoaded$(): Observable<boolean> {
    return this._heatmapDataLoaded$.asObservable();
  }

  highCorrelationData$!: Observable<SubjectGradeCorrelation[]>;
  lowCorrelationData$!: Observable<SubjectGradeCorrelation[]>;
  noCorrelationData$!: Observable<SubjectGradeCorrelation[]>;

  private readonly _heatmapDataLoaded$: BehaviorSubject<boolean> =
    new BehaviorSubject(false);

  private readonly _chartOptions: ApexChartOptions;
  private readonly _destroy$: ReplaySubject<void> = new ReplaySubject(1);

  constructor(
    private readonly subjectGradeCorrelationService: SubjectGradeCorrelationService,
  ) {
    this._chartOptions = {
      series: [],
      chart: {
        type: 'heatmap',
        height: '800px',
      },
      dataLabels: {
        enabled: true,
      },
      colors: ['#008FFB'],
      title: {},
      plotOptions: {
        heatmap: {
          enableShades: true,
          reverseNegativeShade: true,
          colorScale: {
            inverse: false,
            ranges: [
              { from: -1, to: -0.75, color: '#5E0B15' },
              { from: -0.75, to: -0.5, color: '#D32F2F' },
              { from: -0.5, to: -0.25, color: '#F57C00' },
              { from: -0.25, to: 0, color: '#FFEB3B' },
              { from: 0, to: 0.25, color: '#AEEA00' },
              { from: 0.25, to: 0.5, color: '#388E3C' },
              { from: 0.5, to: 0.75, color: '#1976D2' },
              { from: 0.75, to: 1, color: '#4A148C' },
            ],
          },
        },
      },
      xAxis: { categories: [] },
      responsive: [
        {
          breakpoint: 768,
          options: {
            chart: {
              width: '100%',
            },
            legend: {
              position: 'bottom',
            },
            plotOptions: {
              bar: {
                horizontal: true,
              },
            },
          },
        },
        {
          breakpoint: 480,
          options: {
            chart: {
              width: '100%',
              height: 300,
            },
            legend: {
              position: 'bottom',
            },
            plotOptions: {
              bar: {
                horizontal: true,
              },
            },
          },
        },
      ],
    };
  }

  public onTabChange(event: MatTabChangeEvent) {
    switch (event.index) {
      case 0:
        if (!this._heatmapDataLoaded$.value) {
          this.loadHeatmapData();
        }
        break;
      case 1:
        if (!this.highCorrelationData$) {
          this.loadHighCorrelationData();
        }
        break;
      case 2:
        if (!this.lowCorrelationData$) {
          this.loadLowCorrelationData();
        }
        break;
      case 3:
        if (!this.noCorrelationData$) {
          this.loadNoCorrelationData();
        }
        break;
    }
  }

  ngOnInit() {
    this.loadHeatmapData();
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  private groupByFirstSubject(
    data: SubjectGradeCorrelation[],
  ): SubjectGradeCorrelation[][] {
    const groupedData = data.reduce(
      (
        accumulator: Record<string, SubjectGradeCorrelation[]>,
        currentValue,
      ) => {
        const subjectName = currentValue.firstSubject.name;

        if (!accumulator[subjectName]) {
          accumulator[subjectName] = [];
        }

        accumulator[subjectName].push(currentValue);

        return accumulator;
      },
      {},
    );

    return Object.values(groupedData);
  }

  private loadHeatmapData(): void {
    this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation()
      .pipe(takeUntil(this._destroy$))
      .subscribe((data: SubjectGradeCorrelation[]) => {
        this.chartOptions.series = [];

        const groupedData = this.groupByFirstSubject(data);

        groupedData.sort((a, b) =>
          a[0].firstSubject.name.localeCompare(b[0].firstSubject.name),
        );
        groupedData.forEach((subjectCorrelation: SubjectGradeCorrelation[]) => {
          subjectCorrelation.sort((a, b) =>
            a.secondSubject.name.localeCompare(b.secondSubject.name),
          );
          const subjectName: string = subjectCorrelation[0].firstSubject?.name;
          const dataPoints: { x: string; y: string }[] = [];

          subjectCorrelation.forEach((correlation: SubjectGradeCorrelation) => {
            dataPoints.push({
              x: correlation.secondSubject.name,
              y: correlation.correlation.toFixed(2),
            });
          });

          this.chartOptions.series.push({
            name: subjectName,
            data: dataPoints,
            group: subjectName,
          });
        });

        this._heatmapDataLoaded$.next(true);
      });
  }

  private loadHighCorrelationData() {
    this.highCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(0.75, Operator.GREATER_OR_EQUAL)
      .pipe(takeUntil(this._destroy$));
  }

  private loadLowCorrelationData() {
    this.lowCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(-0.75, Operator.LESS_OR_EQUAL)
      .pipe(takeUntil(this._destroy$));
  }

  private loadNoCorrelationData() {
    this.noCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(-0.05, Operator.GREATER_OR_EQUAL)
      .pipe(
        takeUntil(this._destroy$),
        switchMap(
          (negativeNeutralCorrelationData: SubjectGradeCorrelation[]) => {
            const positiveNeutralCorrelation$ =
              this.subjectGradeCorrelationService.getSubjectGradeCorrelation(
                0.05,
                Operator.LESS_OR_EQUAL,
              );
            return forkJoin([
              positiveNeutralCorrelation$,
              of(negativeNeutralCorrelationData),
            ]);
          },
        ),
        map(([positiveNeutralCorrelation, negativeNeutralCorrelationData]) => {
          return [
            ...positiveNeutralCorrelation,
            ...negativeNeutralCorrelationData,
          ];
        }),
      );
  }
}
