import {
  AfterViewInit,
  ChangeDetectorRef,
  Component,
  ElementRef,
  inject,
  OnDestroy,
  OnInit,
  signal,
  ViewChild,
} from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Location } from '@angular/common';

import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Chart as chartJs,
  ChartConfiguration,
  ChartData,
  ChartItem,
  ChartType,
  Filler,
  Legend,
  LinearScale,
  LineController,
  LineElement,
  PointElement,
  RadarController,
  RadialLinearScale,
  TimeScale,
  Title,
  Tooltip,
} from 'chart.js';
import { GradeAverageByYearDto, SubjectExtendedDto } from '../../types';
import { SubjectService } from '@services/subject.service';
import { MatCard } from '@angular/material/card';
import { MatIcon } from '@angular/material/icon';
import { RadarChartComponent, RadarChartOptions } from '@components/charts/radar-chart.component';

@Component({
  selector: 'app-subject-detail',
  standalone: true,
  imports: [MatCard, MatIcon, RadarChartComponent],
  templateUrl: './subject-detail.component.html',
  styleUrl: './subject-detail.component.scss',
})
export class SubjectDetailComponent
  implements OnInit, AfterViewInit, OnDestroy
{
  @ViewChild('barChart') public barChartRef!: ElementRef<HTMLCanvasElement>;
  @ViewChild('lineChart') public lineChartRef?: ElementRef<HTMLCanvasElement>;
  public subjectData!: SubjectExtendedDto;
  public loading = true;
  public radarChartOptions: RadarChartOptions | null = null;
  private barChart!: Chart;
  private barCtx!: ChartItem;
  private lineChart!: Chart;
  private lineCtx!: ChartItem;

  // Signals for reactive state management
  public gradeAveragesData = signal<GradeAverageByYearDto[]>([]);
  public hasGradeAveragesData = signal<boolean | null>(null); // null = loading, true = has data, false = no data

  private colors = [
    'rgba(255, 99, 132, 0.8)',
    'rgba(54, 162, 235, 0.8)',
    'rgba(255, 206, 86, 0.8)',
    'rgba(75, 192, 192, 0.8)',
    'rgba(153, 102, 255, 0.8)',
    'rgba(255, 159, 64, 0.8)',
    'rgba(128, 128, 128, 0.8)',
    'rgba(255, 0, 255, 0.8)',
    'rgba(0, 255, 255, 0.8)',
    'rgba(0, 128, 0, 0.8)',
    'rgba(128, 0, 128, 0.8)',
    'rgba(0, 0, 255, 0.8)',
  ];

  private barChartLabels: string[] = ['A', 'B', 'C', 'D', 'E', 'Fx'];
  private barChartData: ChartData<'bar'> = {
    labels: this.barChartLabels,
    datasets: [
      {
        label: 'Percentuálny podiel známky',
        data: this.generateRandomValues(100, this.barChartLabels.length), //TODO: nahradit realnymi datami
        backgroundColor: this.colors,
        borderColor: this.colors,
        borderWidth: 1,
      },
    ],
  };

  public barChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    aspectRatio: 1,
    scales: {
      x: {
        beginAtZero: true,
      },
      y: {
        beginAtZero: true,
        max: 100,
      },
    },
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        mode: 'nearest',
        axis: 'x',
        intersect: false,
      },
      title: {
        display: true,
        text: 'Percentuálny podiel známok',
        font: {
          size: 16,
        },
      },
    },
  };

  public barChartType: ChartType = 'bar';

  private lineChartData: ChartData<'line'> = {
    labels: [],
    datasets: [
      {
        label: 'Priemerná známka',
        data: [],
        borderColor: 'rgb(14, 116, 144)',
        backgroundColor: 'rgba(14, 116, 144, 0.1)',
        tension: 0.4,
        fill: true,
        pointRadius: 5,
        pointHoverRadius: 7,
      },
    ],
  };

  public lineChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    aspectRatio: 1,
    scales: {
      x: {
        beginAtZero: true,
      },
      y: {
        beginAtZero: true,
        max: 5,
        reverse: true, // Lower grade number is better (1 is best, 5 is worst)
        ticks: {
          stepSize: 0.5,
        },
      },
    },
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        mode: 'index',
        intersect: false,
        callbacks: {
          afterLabel: (context) => {
            const dataIndex = context.dataIndex;
            const data = this.gradeAveragesData();
            if (data[dataIndex]) {
              return `Počet študentov: ${data[dataIndex].studentCount}`;
            }
            return '';
          },
        },
      },
      title: {
        display: true,
        text: 'Vývoj priemernej známky v rokoch',
        font: {
          size: 16,
        },
      },
    },
  };

  public lineChartType: ChartType = 'line';

  private readonly subjectService = inject(SubjectService);
  private readonly activateRoute = inject(ActivatedRoute);
  private readonly location = inject(Location);
  private readonly cdr = inject(ChangeDetectorRef);

  constructor() {
    chartJs.register(
      CategoryScale,
      LinearScale,
      PointElement,
      LineElement,
      LineController,
      TimeScale,
      Title,
      Tooltip,
      Legend,
      RadialLinearScale,
      RadarController,
      Filler,
      BarController,
      BarElement,
    );
  }

  ngAfterViewInit(): void {
    this.initBarChart();
  }

  private initBarChart(): void {
    const barCanvas = this.barChartRef.nativeElement;
    const barValue = barCanvas.getContext('2d');

    if (barValue) {
      this.barCtx = barValue;
      this.generateBarChart();
    }
  }

  private initLineChart(): void {
    if (!this.lineChartRef) return;

    const lineCanvas = this.lineChartRef.nativeElement;
    const lineValue = lineCanvas.getContext('2d');

    if (lineValue) {
      this.lineCtx = lineValue;
      this.generateLineChart();
      this.updateLineChart(this.gradeAveragesData());
    }
  }

  ngOnInit() {
    this.activateRoute.params.subscribe((paramsData) => {
      this.subjectService
        .getExtendedSubjectByCode(paramsData['subjectCode'])
        .subscribe((data) => {
          this.subjectData = data;
          this.loading = false;

          // Initialize radar chart with empty data first for animation
          this.initializeRadarChartWithEmptyData();

          // Then update with real data after a short delay for animation
          setTimeout(() => {
            this.updateRadarChartOptions();
          }, 100);

          this.updateCharts();

          // Fetch grade averages by year
          this.subjectService
            .getGradeAveragesByYear(data.id)
            .subscribe((gradeData) => {
              console.log('Grade averages by year:', gradeData);
              this.gradeAveragesData.set(gradeData);
              this.hasGradeAveragesData.set(gradeData.length > 0);

              // Trigger change detection and initialize line chart after view updates
              if (gradeData.length > 0) {
                this.cdr.detectChanges();
                // Use setTimeout to ensure the canvas is in the DOM after @if renders
                setTimeout(() => {
                  this.initLineChart();
                }, 0);
              }
            });
        });
    });
  }

  ngOnDestroy(): void {
    if (this.barChart) {
      this.barChart.destroy();
    }
    if (this.lineChart) {
      this.lineChart.destroy();
    }
  }

  goBack(): void {
    this.location.back();
  }

  private updateCharts() {

    if (this.barChart) {
      this.barChart.data.datasets[0].data = this.generateRandomValues(
        100,
        this.barChartLabels.length,
      ); // TODO: Replace with real data
      this.barChart.update();
    }
  }

  private generateBarChart() {
    this.barChart = new Chart(this.barCtx, {
      type: this.barChartType,
      data: this.barChartData,
      options: this.barChartOptions,
    });
  }

  private generateLineChart() {
    this.lineChart = new Chart(this.lineCtx, {
      type: this.lineChartType,
      data: this.lineChartData,
      options: this.lineChartOptions,
    });
  }

  private updateLineChart(data: GradeAverageByYearDto[]) {
    if (!this.lineChart) return;

    this.lineChart.data.labels = data.map(d => `Rok ${d.year}`);
    this.lineChart.data.datasets[0].data = data.map(d => d.averageGrade);
    this.lineChart.update();
  }

  private initializeRadarChartWithEmptyData() {
    if (!this.subjectData) return;

    const labels = this.getRadarChartLabels();
    const emptyData = new Array(labels.length).fill(0);

    this.radarChartOptions = {
      data: {
        labels: labels,
        data: emptyData,
        label: 'Focus predmetu',
      },
      title: 'Zameranie predmetu',
      colors: {
        borderColor: '#f97316',
        pointBackgroundColor: '#fff',
        pointBorderColor: '#f97316',
        pointHoverBackgroundColor: '#f97316',
        pointHoverBorderColor: '#fff',
      },
      scales: {
        suggestedMin: 0,
        suggestedMax: 10,
        angleLineColor: 'rgba(14, 116, 144, 0.1)',
        gridColor: 'rgba(14, 116, 144, 0.1)',
        pointLabelColor: '#475569',
        pointLabelFontSize: 12,
        showTicks: false,
      },
      legend: {
        display: false,
      },
      responsive: true,
      maintainAspectRatio: false,
    };
  }

  private updateRadarChartOptions() {
    if (!this.subjectData || !this.subjectData.focusDTO) return;

    this.radarChartOptions = {
      data: {
        labels: this.getRadarChartLabels(),
        data: Object.values(this.subjectData.focusDTO),
        label: 'Focus predmetu',
      },
      title: 'Zameranie predmetu',
      colors: {
        borderColor: '#f97316',
        pointBackgroundColor: '#fff',
        pointBorderColor: '#f97316',
        pointHoverBackgroundColor: '#f97316',
        pointHoverBorderColor: '#fff',
      },
      scales: {
        suggestedMin: 0,
        suggestedMax: 10,
        angleLineColor: 'rgba(14, 116, 144, 0.1)',
        gridColor: 'rgba(14, 116, 144, 0.1)',
        pointLabelColor: '#475569',
        pointLabelFontSize: 12,
        showTicks: false,
      },
      legend: {
        display: false,
      },
      responsive: true,
      maintainAspectRatio: false,
    };
  }

  private getRadarChartLabels(): string[] {
    const focusLabelMapping: { [key: string]: string } = {
      mathFocus: 'Matematika',
      logicFocus: 'Logika',
      programmingFocus: 'Programovanie',
      designFocus: 'Dizajn',
      economicsFocus: 'Ekonomika',
      managementFocus: 'Manažment',
      hardwareFocus: 'Hardvér',
      networkFocus: 'Sieťové technológie',
      dataFocus: 'Práca s dátami',
      testingFocus: 'Testovanie',
      languageFocus: 'Jazyky',
      physicalFocus: 'Fyzické zameranie',
    };

    return this.subjectData && this.subjectData.focusDTO
      ? Object.keys(this.subjectData.focusDTO).map(
          (key) => focusLabelMapping[key],
        )
      : [];
  }


  private generateRandomValues(sum: number, count: number): number[] {
    const values = Array.from({ length: count }, () => Math.random());
    const total = values.reduce((acc, val) => acc + val, 0);
    return values.map((val) => (val / total) * sum);
  }
}
