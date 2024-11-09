import { Component, OnDestroy, OnInit } from '@angular/core';
import { ApexChartOptions, SubjectGradeCorrelation } from '../types';
import { ReplaySubject, takeUntil } from 'rxjs';
import { SubjectGradeCorrelationService } from '../services/subject-grade-correlation.service';
import { NgApexchartsModule } from 'ng-apexcharts';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { MatInput } from '@angular/material/input';
import { FormsModule } from '@angular/forms';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatTab, MatTabGroup } from '@angular/material/tabs';

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
    MatTab
  ],
  templateUrl: './subject-grade-correlation.component.html',
  styleUrl: './subject-grade-correlation.component.scss'
})
export class SubjectGradeCorrelationComponent implements OnInit, OnDestroy {
  get chartOptions(): ApexChartOptions {
    return this._chartOptions;
  }

  public dataLoaded = false;

  private readonly _chartOptions: ApexChartOptions;
  private readonly _destroy$: ReplaySubject<void> = new ReplaySubject(1);


  constructor(private readonly subjectGradeCorrelationService: SubjectGradeCorrelationService) {
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
              { from: -1, to: -0.75, color: '#5E0B15' }, // Very strong negative - Dark maroon
              { from: -0.75, to: -0.5, color: '#D32F2F' }, // Strong negative - Deep red
              { from: -0.5, to: -0.25, color: '#F57C00' }, // Moderate negative - Burnt orange
              { from: -0.25, to: 0, color: '#FFEB3B' }, // Weak negative - Bright yellow
              { from: 0, to: 0.25, color: '#AEEA00' }, // Weak positive - Lime green
              { from: 0.25, to: 0.5, color: '#388E3C' }, // Moderate positive - Forest green
              { from: 0.5, to: 0.75, color: '#1976D2' }, // Strong positive - Royal blue
              { from: 0.75, to: 1, color: '#4A148C' } // Very strong positive - Deep purple
            ]
          }
        }
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
              position: 'bottom'
            },
            plotOptions: {
              bar: {
                horizontal: true // optional example for responsiveness
              }
            }
          }
        },
        {
          breakpoint: 480,
          options: {
            chart: {
              width: '100%',
              height: 300 // Use a numeric value instead of a string
            },
            legend: {
              position: 'bottom'
            },
            plotOptions: {
              bar: {
                horizontal: true // optional example for responsiveness
              }
            }
          }
        }
      ]
    };

  }

  ngOnInit() {
    this.subjectGradeCorrelationService.getSubjectGradeCorrelationService()
      .pipe(takeUntil(this._destroy$))
      .subscribe((data: SubjectGradeCorrelation[]) => {
        this.chartOptions.series = [];

        // Group data by first subject
        const groupedData = this.groupByFirstSubject(data);

        groupedData.sort((a, b) => a[0].firstSubject.name.localeCompare(b[0].firstSubject.name));
        groupedData.forEach((subjectCorrelation: SubjectGradeCorrelation[]) => {
          subjectCorrelation.sort((a, b) => a.secondSubject.name.localeCompare(b.secondSubject.name));
          const subjectName: string = subjectCorrelation[0].firstSubject?.name;
          const dataPoints: { x: string; y: string }[] = [];

          subjectCorrelation.forEach((correlation: SubjectGradeCorrelation) => {
            dataPoints.push({ x: correlation.secondSubject.name, y: correlation.correlation.toFixed(2) });
          });

          this.chartOptions.series.push({ name: subjectName, data: dataPoints, group: subjectName });
        });

        this.dataLoaded = true;
      });
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  private groupByFirstSubject(data: SubjectGradeCorrelation[]): SubjectGradeCorrelation[][] {
    const groupedData = data.reduce((accumulator: Record<string, SubjectGradeCorrelation[]>, currentValue) => {
      const subjectName = currentValue.firstSubject.name;

      if (!accumulator[subjectName]) {
        accumulator[subjectName] = [];
      }

      accumulator[subjectName].push(currentValue);

      return accumulator;
    }, {});

    return Object.values(groupedData);

  }
}
