import { Component, effect, ElementRef, Input, Signal, ViewChild } from '@angular/core';
import { FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Section } from '../../../types';
import { MatStepLabel, MatStepperNext, MatStepperPrevious } from '@angular/material/stepper';
import { MatButton } from '@angular/material/button';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import { NgForOf } from '@angular/common';
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  Chart as chartJs,
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

@Component({
  selector: 'app-focus-step',
  standalone: true,
  imports: [
    FormsModule,
    ReactiveFormsModule,
    MatStepLabel,
    MatButton,
    MatStepperNext,
    MatStepperPrevious,
    FormQuestionComponent,
    NgForOf,
  ],
  templateUrl: './focus-step.component.html',
  styleUrl: './focus-step.component.scss',
})
export class FocusStepComponent {
  @Input() section!: Section;
  @Input() formGroup!: FormGroup;
  @Input() activeStep!: Signal<number>;
  @ViewChild('radarChart') chart!: ElementRef<HTMLCanvasElement>;
  radarChart: Chart | undefined;
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

  chartDatasets: ChartDataset[] = [
    {
      data: [],
    },
  ];


  constructor() {
    effect(
      () => {
        if (this.activeStep() !== 2) {
          return;
        }

        if (!this.radarChart) {
          this.initializeRadarChart();
        }
      },
    );

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

  initializeRadarChart(): void {
    const canvas = this.chart.nativeElement;
    const value = canvas.getContext('2d');

    if (value) {
      const focusLabelMapping: { [key: string]: string } = {
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
          responsive: false,
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

      this.chartDatasets[0].data = Object.values(
        Object.fromEntries(
          Object.keys(focusLabelMapping).map((key) => [
            key,
            this.formGroup.value[key],
          ]),
        ),
      ) as number[];

      this.radarChart.update();

      this.formGroup.valueChanges.pipe().subscribe((data) => {
        const sortedData = Object.fromEntries(
          Object.keys(focusLabelMapping).map((key) => [key, data[key]]),
        );

        this.chartDatasets[0].data = Object.values(sortedData) as number[];
        this.radarChart?.update();
      });
    }
  }
}
