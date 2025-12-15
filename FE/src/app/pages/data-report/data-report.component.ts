import { Component, inject, OnDestroy, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { FormsModule } from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';
import { DataReportService } from '@services/data-report.service';
import { DataReportDto, StudentTrendDataPoint } from '../../types';
import {
  ApexAxisChartSeries,
  ApexChart,
  ApexXAxis,
  ApexDataLabels,
  ApexStroke,
  ApexYAxis,
  ApexTitleSubtitle,
  ApexLegend,
  ApexGrid,
  NgApexchartsModule
} from 'ng-apexcharts';

export type ChartOptions = {
  series: ApexAxisChartSeries;
  chart: ApexChart;
  xaxis: ApexXAxis;
  yaxis: ApexYAxis;
  dataLabels: ApexDataLabels;
  stroke: ApexStroke;
  title: ApexTitleSubtitle;
  legend: ApexLegend;
  grid: ApexGrid;
  colors: string[];
};

@Component({
  selector: 'app-data-report',
  templateUrl: './data-report.component.html',
  standalone: true,
  styleUrls: ['./data-report.component.scss'],
  imports: [
    CommonModule,
    MatCardModule,
    MatProgressBarModule,
    MatSelectModule,
    MatFormFieldModule,
    MatIconModule,
    FormsModule,
    NgApexchartsModule,
  ],
})
export class DataReportComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private readonly dataReportService = inject(DataReportService);

  isLoading = false;
  dataReport: DataReportDto | null = null;

  selectedStudyProgram: string = 'all';

  studyPrograms = [
    { value: 'all', label: 'Všetky' },
    { value: 'informatika', label: 'Informatika' },
    { value: 'manazment', label: 'Manažment' },
  ];

  public chartOptions: Partial<ChartOptions> | null = null;

  ngOnInit(): void {
    this.loadDataReport();
  }

  ngOnDestroy(): void {
    this._destroy$.next();
    this._destroy$.complete();
  }

  loadDataReport(): void {
    this.isLoading = true;
    this.dataReportService
      .getDataReport()
      .pipe(takeUntil(this._destroy$))
      .subscribe({
        next: (data) => {
          this.dataReport = data;
          this.initializeChart(data.studentTrend);
          this.isLoading = false;
        },
        error: () => {
          this.isLoading = false;
        },
      });
  }

  initializeChart(trendData: StudentTrendDataPoint[]): void {
    const series: ApexAxisChartSeries = [];

    // Add series based on selected study program
    if (this.selectedStudyProgram === 'all' || this.selectedStudyProgram === 'informatika') {
      series.push({
        name: 'Informatika',
        data: trendData.map((d) => d.informatika),
      });
    }

    if (this.selectedStudyProgram === 'all' || this.selectedStudyProgram === 'manazment') {
      series.push({
        name: 'Manažment',
        data: trendData.map((d) => d.manazment),
      });
    }

    this.chartOptions = {
      series: series,
      chart: {
        height: 350,
        type: 'line',
        zoom: {
          enabled: false,
        },
        toolbar: {
          show: true,
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        curve: 'smooth',
        width: 3,
      },
      title: {
        text: 'Vývoj počtu študentov',
        align: 'left',
      },
      grid: {
        row: {
          colors: ['#f3f3f3', 'transparent'],
          opacity: 0.5,
        },
      },
      xaxis: {
        categories: trendData.map((d) => d.year.toString()),
        title: {
          text: 'Rok',
        },
      },
      yaxis: {
        title: {
          text: 'Počet študentov',
        },
      },
      legend: {
        position: 'top',
        horizontalAlign: 'right',
      },
      colors: ['#2E93fA', '#FF9800'],
    };
  }

  onFilterChange(): void {
    if (this.dataReport) {
      this.initializeChart(this.dataReport.studentTrend);
    }
  }
}

