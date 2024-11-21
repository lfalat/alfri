import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { SubjectService } from '../services/subject.service';
import { SubjectExtendedDto } from '../types';
import { ActivatedRoute } from '@angular/router';
import { NgIf } from '@angular/common';
import {
  BarController, BarElement,
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


@Component({
  selector: 'app-subject-detail',
  standalone: true,
  imports: [
    NgIf,
    BaseChartDirective
  ],
  templateUrl: './subject-detail.component.html',
  styleUrl: './subject-detail.component.scss'
})
export class SubjectDetailComponent implements OnInit {
  @ViewChild('chart') public focusChart!: ElementRef<HTMLCanvasElement>;
  @ViewChild('barChart') public barChartRef!: ElementRef<HTMLCanvasElement>;
  public subjectData!: SubjectExtendedDto;
  public loading = true;
  private chart!: Chart;
  private barChart!: Chart;
  private ctx!: ChartItem;
  private barCtx!: ChartItem;
  private chartDatasets: ChartDataset[] = [
    {
      data: []
    }
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
    'rgba(0, 0, 255, 0.8)'
  ];

  public radarChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    scales: {
      r: {
        angleLines: {
          display: true
        },
        suggestedMin: 0,
        suggestedMax: 100
      }
    },
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        callbacks: {
          label: (context) => {
            const label = context.label || '';
            const value = context.raw || 0;
            return `${label}: ${value}`;
          }
        }
      }
    },
    animations: {}
  };

  public radarChartLabels: string[] = ['Running', 'Swimming', 'Eating', 'Cycling', 'Sleeping', 'Designing', 'Coding'];

  public radarChartData: ChartData<'radar'> = {
    labels: this.radarChartLabels,
    datasets: [
      {
        data: [65, 59, 90, 81, 56, 55, 40],
        label: 'Focus predmetu',
        fill: true,
        backgroundColor: this.colors,
        borderColor: this.colors,
        borderWidth: 1
      }
    ]
  };

  public radarChartType: ChartType = 'radar';

  private barChartLabels: string[] = ['A', 'B', 'C', 'D', 'E', 'Fx'];
  private barChartData: ChartData<'bar'> = {
    labels: this.barChartLabels,
    datasets: [
      {
        label: 'Percentualny podiel znamky',
        data: this.generateRandomValues(100, this.barChartLabels.length),
        backgroundColor: this.colors,
        borderColor: this.colors,
        borderWidth: 1
      }
    ]
  };

  public barChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    scales: {
      x: {
        beginAtZero: true
      },
      y: {
        beginAtZero: true,
        max: 100
      }
    },
    plugins: {
      legend: {
        display: false
      },
      tooltip: {
        mode: 'nearest',
        axis: 'x',
        intersect: false
      }
    },
  };

  public barChartType: ChartType = 'bar';

  constructor(private subjectService: SubjectService, private activateRoute: ActivatedRoute, private elRef: ElementRef) {
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
      BarElement
    );
  }

  private chartGeneration() {
    const canvas = this.focusChart.nativeElement;
    const barCanvas = this.barChartRef.nativeElement;
    const value = canvas.getContext('2d');
    const barValue = barCanvas.getContext('2d');

    if (value && barValue) {
      this.ctx = value;
      this.barCtx = barValue;
      this.generateNewChart();
      this.generateBarChart();
      this.chart.update();
      this.barChart.update();
    }
  }


  ngOnInit() {
    this.activateRoute.params.subscribe(paramsData => {
      this.subjectService.getExtendedSubjectByCode(paramsData['subjectCode']).subscribe(data => {
        this.subjectData = data;
        this.loading = false;
        this.chartGeneration();
      });
    });
  }


  private generateBarChart() {
    this.barChart = new Chart(this.barCtx, {
      type: this.barChartType,
      data: this.barChartData,
      options: this.barChartOptions
    });
  }

  private generateNewChart() {
    this.chart = new Chart(this.ctx, {
      type: 'radar',
      data: {
        labels: Object.keys(this.subjectData?.focusDTO),
        datasets: this.chartDatasets
      },
      options: {
        responsive: true,
        scales: {
          r: {
            angleLines: {
              display: true
            },
            suggestedMin: 0,
            suggestedMax: 10
          }
        },
        plugins: {
          tooltip: {
            callbacks: {
              label: (context) => {
                const label = context.label || '';
                const value = context.raw || 0;
                return `${label}: ${value}`;
              }
            }
          },
          legend: {
            display: false
          }
        }
      }
    });
    this.chartDatasets[0] = this.getNewData();
  }

  private getNewData(): ChartDataset {
    return {
      label: 'Focus predmetu',
      fill: true,
      backgroundColor: this.colors,
      borderColor: this.colors,
      borderWidth: 1,
      data: Object.values(this.subjectData?.focusDTO)
    };
  }

  private generateRandomValues(sum: number, count: number): number[] {
    const values = Array.from({ length: count }, () => Math.random());
    const total = values.reduce((acc, val) => acc + val, 0);
    return values.map(val => (val / total) * sum);
  }
}
