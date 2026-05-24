import { Component, effect, Input, Signal } from '@angular/core';
import { FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Section } from '../../../types';
import { MatStepLabel, MatStepperNext, MatStepperPrevious } from '@angular/material/stepper';
import { MatButton } from '@angular/material/button';
import { FormQuestionComponent } from '@components/form-question/form-question.component';
import {
  RadarChartComponent,
  RadarChartOptions,
  getFocusChartLabels,
  extractFocusData,
} from '@components/charts';

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
    RadarChartComponent,
  ],
  templateUrl: './focus-step.component.html',
  styleUrl: './focus-step.component.scss',
})
export class FocusStepComponent {
  @Input() section!: Section;
  @Input() formGroup!: FormGroup;
  @Input() activeStep!: Signal<number>;

  radarChartOptions: RadarChartOptions | null = null;

  constructor() {
    effect(() => {
      if (this.activeStep() !== 2) {
        return;
      }

      if (!this.radarChartOptions) {
        this.initializeRadarChart();
      }
    });
  }

  initializeRadarChart(): void {
    const chartData = extractFocusData(this.formGroup.value);

    this.radarChartOptions = {
      data: {
        labels: getFocusChartLabels(),
        data: chartData,
        label: 'Skóre záujmu',
      },
      scales: {
        suggestedMin: 0,
        suggestedMax: 10,
        stepSize: 2,
      },
    };

    // Subscribe to form changes to update chart
    this.formGroup.valueChanges.subscribe((data) => {
      if (this.radarChartOptions) {
        const updatedData = extractFocusData(data);
        this.radarChartOptions = {
          ...this.radarChartOptions,
          data: {
            ...this.radarChartOptions.data,
            data: updatedData,
          },
        };
      }
    });
  }
}
