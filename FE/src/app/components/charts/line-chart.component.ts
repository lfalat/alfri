import { Component, computed, input, ViewChild } from '@angular/core';
import {
  NgApexchartsModule,
  ApexChart,
  ApexDataLabels,
  ApexGrid,
  ApexLegend,
  ApexStroke,
  ApexTitleSubtitle,
  ApexXAxis,
  ApexYAxis,
  ApexOptions,
  ChartComponent,
  ApexAxisChartSeries,
} from 'ng-apexcharts';

@Component({
  selector: 'app-line-chart',
  standalone: true,
  imports: [NgApexchartsModule],
  template: `
    @if (chartOptions()) {
      <div class="chart-container">
        <apx-chart
          #chart
          [series]="chartOptions().series || []"
          [chart]="computedChartOptions()"
          [xaxis]="computedXAxisOptions()"
          [yaxis]="computedYAxisOptions()"
          [dataLabels]="computedDataLabelsOptions()"
          [stroke]="computedStrokeOptions()"
          [title]="computedTitleOptions()"
          [legend]="computedLegendOptions()"
          [grid]="computedGridOptions()"
          [colors]="computedColors()"
        ></apx-chart>
      </div>
    }
  `,
  styles: [
    `
      .chart-container {
        width: 100%;
        height: 100%;
      }
    `,
  ],
})
export class LineChartComponent {
  @ViewChild('chart') chart?: ChartComponent;

  // Input for chart options
  chartOptions = input.required<ApexOptions>();

  // Height input (default: 350)
  height = input<number>(350);

  // Public method to update series without re-rendering the entire chart
  public updateSeries(newSeries: ApexAxisChartSeries, animate: boolean = false): void {
    if (this.chart) {
      this.chart.updateSeries(newSeries, animate);
    }
  }

  // Computed chart options with defaults
  computedChartOptions = computed<ApexChart>(() => {
    const options = this.chartOptions();
    return {
      height: this.height(),
      type: 'line',
      zoom: {
        enabled: false,
      },
      toolbar: {
        show: true,
      },
      ...options.chart,
    };
  });

  computedDataLabelsOptions = computed<ApexDataLabels>(() => {
    const options = this.chartOptions();
    return {
      enabled: false,
      ...options.dataLabels,
    };
  });

  computedStrokeOptions = computed<ApexStroke>(() => {
    const options = this.chartOptions();
    return {
      curve: 'smooth',
      width: 3,
      ...options.stroke,
    };
  });

  computedXAxisOptions = computed<ApexXAxis>(() => {
    const options = this.chartOptions();
    return {
      ...options.xaxis,
    };
  });

  computedYAxisOptions = computed<ApexYAxis | ApexYAxis[]>(() => {
    const options = this.chartOptions();
    return {
      ...options.yaxis,
    };
  });

  computedTitleOptions = computed<ApexTitleSubtitle>(() => {
    const options = this.chartOptions();
    return {
      align: 'left',
      ...options.title,
    };
  });

  computedGridOptions = computed<ApexGrid>(() => {
    const options = this.chartOptions();
    return {
      row: {
        colors: ['#f3f3f3', 'transparent'],
        opacity: 0.5,
      },
      ...options.grid,
    };
  });

  computedLegendOptions = computed<ApexLegend>(() => {
    const options = this.chartOptions();
    return {
      position: 'top',
      horizontalAlign: 'right',
      ...options.legend,
    };
  });

  computedColors = computed<string[]>(() => {
    const options = this.chartOptions();
    return options.colors || ['#2E93fA', '#FF9800', '#66DA26', '#546E7A'];
  });
}
