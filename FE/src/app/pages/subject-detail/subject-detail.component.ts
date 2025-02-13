import { AfterViewInit, Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { SubjectService } from '@services/subject.service';
import { ActivatedRoute } from '@angular/router';
import { NgIf } from '@angular/common';
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Chart as chartJs,
  ChartConfiguration,
  ChartData,
  ChartDataset,
  ChartItem,
  ChartType,
  Filler,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  RadarController,
  RadialLinearScale,
  TimeScale,
  Title,
  Tooltip,
} from 'chart.js';
import { BaseChartDirective } from 'ng2-charts';
import { SubjectExtendedDto } from '../../types';
import { MatCard, MatCardContent, MatCardHeader, MatCardTitle } from '@angular/material/card';

@Component({
  selector: 'app-subject-detail',
  standalone: true,
  imports: [NgIf, BaseChartDirective, MatCard, MatCardHeader, MatCardContent, MatCardTitle],
  templateUrl: './subject-detail.component.html',
  styleUrl: './subject-detail.component.scss',
})
export class SubjectDetailComponent implements OnInit, AfterViewInit {
  @ViewChild('chart') public focusChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('barChart') public barChartRef!: ElementRef<HTMLCanvasElement>;
  public subjectData: SubjectExtendedDto | undefined;
  public loading = true;
  private chart!: Chart;
  private barChart!: Chart;
  private ctx!: ChartItem;
  private barCtx!: ChartItem;
  private chartDatasets: ChartDataset[] = [
    {
      data: [],
    },
  ];

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

  constructor(
    private subjectService: SubjectService,
    private activateRoute: ActivatedRoute,
  ) {
    chartJs.register(
      CategoryScale,
      LinearScale,
      PointElement,
      LineElement,
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
    this.chartGeneration();
  }

  private chartGeneration() {
    const canvas = this.focusChart.nativeElement;
    const barCanvas = this.barChartRef.nativeElement;
    const value = canvas.getContext('2d');
    const barValue = barCanvas.getContext('2d');

    if (value && barValue) {
      this.ctx = value;
      this.barCtx = barValue;
      this.generateRadarChart();
      this.generateBarChart();
    }
  }

  ngOnInit() {
    this.activateRoute.params.subscribe((paramsData) => {
      this.subjectService
        .getExtendedSubjectByCode(paramsData['subjectCode'])
        .subscribe((data) => {
          this.subjectData = data;
          this.loading = false;
          this.updateCharts();
        });
    });
  }

  private updateCharts() {
    if (this.chart) {
      this.chart.data.labels = this.getRadarChartLabels();
      this.chart.data.datasets = [this.getFocusData()];
      this.chart.update();
    }

    if (this.barChart) {
      this.barChart.data.datasets[0].data = this.generateRandomValues(100, this.barChartLabels.length); // TODO: Replace with real data
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

  private generateRadarChart() {
    this.chart = new Chart(this.ctx, {
      type: 'radar',
      data: {
        labels: this.getRadarChartLabels(),
        datasets: this.chartDatasets,
      },
      options: {
        responsive: true,
        scales: {
          r: {
            angleLines: {
              display: true,
            },
            suggestedMin: 0,
            suggestedMax: 10,
          },
        },
        plugins: {
          title: {
            display: true,
            text: 'Zameranie predmetu',
            font: {
              size: 16,
            },
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const label = context.label || '';
                const value = context.raw || 0;
                return `${label}: ${value}`;
              },
            },
          },
          legend: {
            display: false,
          },
        },
      },
    });
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

    return this.subjectData ? Object.keys(this.subjectData.focusDTO).map((key) => focusLabelMapping[key]) : [];
  }

  private getFocusData(): ChartDataset {
    return {
      label: 'Focus predmetu',
      fill: true,
      backgroundColor: this.colors,
      borderColor: this.colors,
      borderWidth: 1,
      data: this.subjectData ? Object.values(this.subjectData.focusDTO) : [],
    };
  }

  private generateRandomValues(sum: number, count: number): number[] {
    const values = Array.from({ length: count }, () => Math.random());
    const total = values.reduce((acc, val) => acc + val, 0);
    return values.map((val) => (val / total) * sum);
  }
}
