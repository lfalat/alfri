import {
  AfterViewInit,
  Component,
  ElementRef,
  Input,
  OnInit,
  ViewChild,
} from '@angular/core';
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart as chartJs,
  Chart,
  ChartDataset,
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
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
  MatTableDataSource,
} from '@angular/material/table';
import { NgForOf, NgIf } from '@angular/common';
import { MatChip, MatChipSet } from '@angular/material/chips';
import { AnsweredForm, StudyPrograms } from '../../types';
import { MatPaginator } from '@angular/material/paginator';

@Component({
  selector: 'app-user-form-results',
  standalone: true,
  imports: [
    MatCell,
    NgForOf,
    MatChip,
    MatChipSet,
    MatRow,
    MatRowDef,
    MatHeaderRow,
    MatCellDef,
    MatHeaderCell,
    MatColumnDef,
    MatTable,
    MatHeaderRowDef,
    MatHeaderCellDef,
    NgIf,
    MatPaginator,
  ],
  templateUrl: './user-form-results.component.html',
  styleUrl: './user-form-results.component.scss',
})
export class UserFormResultsComponent implements OnInit, AfterViewInit {
  @Input()
  existingAnswers: AnsweredForm | undefined;
  @ViewChild('radarChart') chart!: ElementRef<HTMLCanvasElement>;
  radarChart: Chart | undefined;
  protected readonly StudyPrograms = StudyPrograms;
  protected readonly Number = Number;

  // Data source for the table
  dataSource: MatTableDataSource<{ subjectName: string; grade: string }> =
    new MatTableDataSource();
  @ViewChild(MatPaginator) paginator!: MatPaginator;

  displayedColumns: string[] = ['nazovPredmetu', 'znamka'];
  chartDatasets: ChartDataset[] = [
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

  constructor() {
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

  ngOnInit(): void {
    if (!this.existingAnswers) {
      return;
    }
    this.dataSource.data = this.existingAnswers.sections[1].questions.map(
      (question) => {
        return {
          subjectName: question.questionTitle,
          grade: question.answers[0].texts[0].textOfAnswer,
        };
      },
    );
  }

  ngAfterViewInit(): void {
    this.initializeRadarChart();
    this.dataSource.paginator = this.paginator;
  }

  initializeRadarChart(): void {
    const canvas = this.chart.nativeElement;
    const value = canvas.getContext('2d');

    if (value) {
      const focusLabelMapping: Record<string, string> = {
        question_matematika_focus: 'Matematika',
        question_logika_focus: 'Logika',
        question_programovanie_focus: 'Programovanie',
        question_dizajn_focus: 'Dizajn',
        question_ekonomika_focus: 'Ekonomika',
        question_manazment_focus: 'Manažment',
        question_hardver_focus: 'Hardvér',
        question_siete_focus: 'Sieťové technológie',
        question_data_focus: 'Práca s dátami',
        question_testovanie_focus: 'Testovanie',
        question_jazyky_focus: 'Jazyky',
        question_fyzicka_aktivita_focus: 'Fyzické zameranie',
      };

      this.radarChart = new Chart(value, {
        type: 'radar',
        data: {
          labels: Object.values(focusLabelMapping),
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

      this.chartDatasets[0] = {
        label: 'Focus predmetu',
        fill: true,
        backgroundColor: this.colors,
        borderColor: this.colors,
        borderWidth: 1,
        data: [],
      };

      const focusesFormData: Record<string, string>[] | undefined =
        this.existingAnswers?.sections[2].questions.map((question) => {
          const focuses: Record<string, string> = {};
          focuses[question.questionIdentifier] =
            question.answers[0].texts[0].textOfAnswer;
          return focuses;
        });

      if (focusesFormData) {
        // Merge all objects in the array into one
        const mergedFocusesFormData = Object.assign({}, ...focusesFormData);

        this.chartDatasets[0].data = Object.values(
          Object.fromEntries(
            Object.keys(focusLabelMapping).map((key) => [
              key,
              mergedFocusesFormData[key],
            ]),
          ),
        ) as number[];
      }

      this.radarChart.update();
    }
  }
}
