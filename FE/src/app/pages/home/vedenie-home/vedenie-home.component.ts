import {
  AfterViewInit,
  Component,
  ElementRef,
  OnDestroy,
  OnInit,
  ViewChild,
  inject,
  NgZone,
  computed,
  signal,
} from '@angular/core';

import { Chart, ChartConfiguration, registerables } from 'chart.js';
import 'echarts-wordcloud';
import * as echarts from 'echarts';
import { EChartsType } from 'echarts';
import {
  FocusCategorySumDTO,
  KeywordDTO,
  StudentYearCountDTO,
  DataReportDto,
  StudyProgramDto,
  StudyProgramId,
  StudentTrendDataPoint,
} from '../../../types';
import { StudentMarksReportComponent } from '@components/student-marks-report/student-marks-report.component';
import { LeadService } from '@services/lead.service';
import { Router } from '@angular/router';
import { forkJoin, Subscription } from 'rxjs';
import { DataReportService } from '@services/data-report.service';
import { StudyProgramService } from '@services/study-program.service';
import { LineChartComponent, PieChartComponent } from '@components/charts';
import { ApexAxisChartSeries, ApexOptions } from 'ng-apexcharts';
import {
  INFORMATICS_STUDY_PROGRAM_ID,
  MANAGEMENT_STUDY_PROGRAM_ID,
} from '../../../const';
import {
  getStudentTrendChartOptions,
  getGradeChartOptions,
  getGradeDistributionChartOptions,
} from '../teacher-home/teacher-home.const';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { FormsModule } from '@angular/forms';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';

const FOCUS_LABEL_MAPPING: Record<string, string> = {
  math_focus: 'Matematika',
  logic_focus: 'Logika',
  programming_focus: 'Programovanie',
  design_focus: 'Dizajn',
  economics_focus: 'Ekonomika',
  management_focus: 'Manažment',
  hardware_focus: 'Hardvér',
  network_focus: 'Sieťové technológie',
  data_focus: 'Práca s dátami',
  testing_focus: 'Testovanie',
  language_focus: 'Jazyky',
  physical_focus: 'Fyzické zameranie',
};

type ChartPayload = {
  keywords: KeywordDTO[];
  categories: FocusCategorySumDTO[];
  studentCounts: StudentYearCountDTO[];
};

const buildWordCloudOptions = (
  keywords: KeywordDTO[],
): echarts.EChartsOption => ({
  series: [
    {
      type: 'wordCloud',
      shape: 'circle',
      sizeRange: [12, 60],
      rotationRange: [-90, 90],
      rotationStep: 45,
      gridSize: 8,
      drawOutOfBound: false,
      layoutAnimation: true,
      textStyle: {
        fontFamily: 'sans-serif',
        fontWeight: 'bold',
        color: () =>
          `rgb(${Math.round(Math.random() * 160)},${Math.round(Math.random() * 160)},${Math.round(Math.random() * 160)})`,
      },
      emphasis: { focus: 'self' },
      data: keywords.map((item) => ({ name: item.keyword, value: item.count })),
    },
  ],
});

const buildFocusPieConfig = (
  categories: FocusCategorySumDTO[],
): ChartConfiguration<'pie', number[], string> => {
  const total = categories.reduce((sum, item) => sum + item.totalSum, 0) || 1;
  const labels = categories.map(
    (item) => FOCUS_LABEL_MAPPING[item.focusCategory] ?? item.focusCategory,
  );
  const percentages = categories.map((item) =>
    Number(((item.totalSum / total) * 100).toFixed(2)),
  );

  return {
    type: 'pie',
    data: {
      labels,
      datasets: [
        {
          data: percentages,
          backgroundColor: [
            '#FF6384',
            '#36A2EB',
            '#FFCE56',
            '#4BC0C0',
            '#9966FF',
            '#FF9F40',
            '#E7E9ED',
            '#8C9EFF',
            '#00CC99',
            '#FF6666',
            '#CC99FF',
            '#66FF66',
          ],
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        tooltip: {
          callbacks: {
            label: (context) => {
              const label = context.label ?? '';
              const value =
                typeof context.raw === 'number'
                  ? context.raw.toFixed(2)
                  : String(context.raw ?? '');
              return `${label}: ${value}%`;
            },
          },
        },
        legend: { position: 'bottom' },
      },
    },
  };
};

const buildYearBarConfig = (
  studentCounts: StudentYearCountDTO[],
): ChartConfiguration<'bar', number[], string> => {
  const labels = studentCounts.map((item) => item.year.toString());
  const counts = studentCounts.map((item) => item.studentsCount);

  return {
    type: 'bar',
    data: {
      labels,
      datasets: [
        {
          label: 'Počet študentov',
          data: counts,
          backgroundColor: '#36A2EB',
          borderColor: '#36A2EB',
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: true, position: 'top' },
        tooltip: {
          callbacks: {
            label: (context) => {
              const label = context.dataset.label ?? '';
              const value =
                typeof context.raw === 'number'
                  ? context.raw.toFixed(2)
                  : String(context.raw ?? '');
              return `${label}: ${value}`;
            },
          },
        },
      },
      scales: {
        y: {
          beginAtZero: true,
          title: { display: true, text: 'Počet študentov' },
        },
        x: {
          title: { display: true, text: 'Rok' },
        },
      },
    },
  };
};

@Component({
  selector: 'app-vedenie-home',
  standalone: true,
  imports: [
    StudentMarksReportComponent,
    LineChartComponent,
    PieChartComponent,
    MatFormFieldModule,
    MatSelectModule,
    FormsModule,
    MatProgressBarModule,
    MatIconModule,
  ],
  templateUrl: './vedenie-home.component.html',
  styleUrl: './vedenie-home.component.scss',
})
export class VedenieHomeComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('wordCloudContainer')
  private readonly wordCloudContainer?: ElementRef<HTMLDivElement>;
  @ViewChild('pieChartCanvas')
  private readonly pieChartCanvas?: ElementRef<HTMLCanvasElement>;
  @ViewChild('barChartCanvas')
  private readonly barChartCanvas?: ElementRef<HTMLCanvasElement>;

  barChart: Chart | undefined;
  wordCloudChart: EChartsType | undefined;
  pieChart: Chart<'pie', number[], string> | undefined;

  wordCloudLoading = true;
  pieChartLoading = true;
  barChartLoading = true;

  private readonly leadService = inject(LeadService);
  private readonly router = inject(Router);
  private readonly zone = inject(NgZone);
  private readonly dataReportService = inject(DataReportService);
  private readonly studyProgramService = inject(StudyProgramService);

  private dataSubscription?: Subscription;
  private reportSubscription?: Subscription;
  private isViewReady = false;
  private chartPayload?: ChartPayload;

  // Signals for teacher-home data
  dataReport = signal<DataReportDto | null>(null);
  selectedStudyProgramId = signal<StudyProgramId | null>(null);
  studyPrograms = signal<StudyProgramDto[]>([]);
  isLoadingReport = signal(false);

  // Computed properties for teacher-home charts
  chartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report) {
      return null;
    }

    const trendData = report.studentTrend;
    const series = this.getSeriesData(trendData);

    return getStudentTrendChartOptions(trendData, series);
  });

  gradeChartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report?.averageGradeByYear) return null;

    return getGradeChartOptions(report.averageGradeByYear);
  });

  gradeDistributionChartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report?.gradeDistribution) return null;

    return getGradeDistributionChartOptions(report.gradeDistribution);
  });

  constructor() {
    Chart.register(...registerables);
  }

  ngOnInit(): void {
    this.loadChartData();
    this.loadTeacherHomeData();
  }

  ngAfterViewInit(): void {
    this.isViewReady = true;
    this.tryRenderCharts();
  }

  ngOnDestroy(): void {
    this.dataSubscription?.unsubscribe();
    this.reportSubscription?.unsubscribe();
    this.disposeCharts();
  }

  redirectToKeywordsPage(word: string): void {
    this.router.navigate(['/keywords'], { state: { word } });
  }

  private loadChartData(): void {
    this.dataSubscription = forkJoin({
      keywords: this.leadService.getAllKeywords(),
      categories: this.leadService.getCategorySums(),
      studentCounts: this.leadService.getStudentCountsByYear(),
    }).subscribe({
      next: (payload) => {
        this.chartPayload = payload;
        this.tryRenderCharts();
      },
      error: (error) => {
        console.error('Error loading dashboard charts', error);
        this.wordCloudLoading = false;
        this.pieChartLoading = false;
        this.barChartLoading = false;
      },
    });
  }

  private tryRenderCharts(): void {
    if (!this.isViewReady || !this.chartPayload) {
      return;
    }

    const { keywords, categories, studentCounts } = this.chartPayload;

    this.scheduleChartInit(() => this.initWordCloud(keywords), 0);
    this.scheduleChartInit(() => this.initPieChart(categories), 50);
    this.scheduleChartInit(() => this.initBarChart(studentCounts), 100);
  }

  private scheduleChartInit(initFn: () => void, delay: number): void {
    this.zone.runOutsideAngular(() => {
      window.setTimeout(() => {
        requestAnimationFrame(initFn);
      }, delay);
    });
  }

  private initWordCloud(keywords: KeywordDTO[]): void {
    const container = this.wordCloudContainer?.nativeElement;
    if (!container) {
      return;
    }

    this.wordCloudChart?.dispose();
    const chart = echarts.init(container);
    chart.setOption(buildWordCloudOptions(keywords));
    chart.off('click');
    chart.on('click', (params) => {
      if (typeof params.name === 'string') {
        this.zone.run(() => this.redirectToKeywordsPage(params.name));
      }
    });

    this.wordCloudChart = chart;
    this.zone.run(() => (this.wordCloudLoading = false));
  }

  private initPieChart(categories: FocusCategorySumDTO[]): void {
    const canvas = this.pieChartCanvas?.nativeElement;
    if (!canvas) {
      return;
    }

    this.pieChart?.destroy();
    this.pieChart = new Chart(canvas, buildFocusPieConfig(categories));
    this.zone.run(() => (this.pieChartLoading = false));
  }

  private initBarChart(studentCounts: StudentYearCountDTO[]): void {
    const canvas = this.barChartCanvas?.nativeElement;
    if (!canvas) {
      return;
    }

    this.barChart?.destroy();
    this.barChart = new Chart(canvas, buildYearBarConfig(studentCounts));
    this.zone.run(() => (this.barChartLoading = false));
  }

  private disposeCharts(): void {
    this.barChart?.destroy();
    this.pieChart?.destroy();
    this.wordCloudChart?.dispose();
  }

  // Teacher-home specific methods
  private loadTeacherHomeData(): void {
    this.isLoadingReport.set(true);
    this.studyProgramService.getAll().subscribe({
      next: (studyPrograms) => {
        this.studyPrograms.set(studyPrograms);
        this.fetchDataReport(this.selectedStudyProgramId());
      },
      error: () => {
        this.isLoadingReport.set(false);
      },
    });
  }

  private fetchDataReport(studyProgramId: StudyProgramId | null): void {
    this.isLoadingReport.set(true);
    this.reportSubscription?.unsubscribe();
    this.reportSubscription = this.dataReportService
      .getDataReport(studyProgramId)
      .subscribe({
        next: (dataReport) => {
          this.dataReport.set(dataReport);
          this.isLoadingReport.set(false);
        },
        error: () => {
          this.isLoadingReport.set(false);
        },
      });
  }

  onStudyProgramChange(studyProgramId: StudyProgramId | null): void {
    this.selectedStudyProgramId.set(studyProgramId);
    this.fetchDataReport(studyProgramId);
  }

  getSeriesData(trendData: StudentTrendDataPoint[]): ApexAxisChartSeries {
    let series: ApexAxisChartSeries = [];

    const selectedId = this.selectedStudyProgramId();
    if (selectedId) {
      const selectedProgram = this.studyPrograms().find(
        (p) => p.id === selectedId,
      );
      if (selectedProgram) {
        series = [
          {
            name: selectedProgram.name,
            data: trendData.map(
              (d: StudentTrendDataPoint) =>
                d.programCounts[selectedId],
            ),
          },
        ];
      }
    } else {
      series = [
        {
          name: 'Informatika',
          data: trendData.map(
            (d) => d.programCounts[INFORMATICS_STUDY_PROGRAM_ID],
          ),
        },
        {
          name: 'Manažment',
          data: trendData.map(
            (d) => d.programCounts[MANAGEMENT_STUDY_PROGRAM_ID],
          ),
        },
      ];
    }

    return series;
  }
}
