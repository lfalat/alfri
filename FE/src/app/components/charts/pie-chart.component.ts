import { Component, computed, input, ViewChild } from '@angular/core';
import {
  NgApexchartsModule,
  ApexChart,
  ApexDataLabels,
  ApexLegend,
  ApexTitleSubtitle,
  ApexOptions,
  ChartComponent,
  ApexNonAxisChartSeries,
  ApexPlotOptions,
  ApexResponsive,
} from 'ng-apexcharts';

@Component({
  selector: 'app-pie-chart',
  standalone: true,
  imports: [NgApexchartsModule],
  template: `
    @if (chartOptions()) {
      <div class="chart-container">
        <apx-chart
          #chart
          [series]="chartOptions().series || []"
          [chart]="computedChartOptions()"
          [labels]="computedLabels()"
          [dataLabels]="computedDataLabelsOptions()"
          [title]="computedTitleOptions()"
          [legend]="computedLegendOptions()"
          [colors]="computedColors()"
          [plotOptions]="computedPlotOptions()"
          [responsive]="computedResponsive()"
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
export class PieChartComponent {
  @ViewChild('chart') chart?: ChartComponent;

  // Input for chart options
  chartOptions = input.required<ApexOptions>();

  // Height input (default: 350)
  height = input<number>(350);

  // Public method to update series without re-rendering the entire chart
  public updateSeries(newSeries: ApexNonAxisChartSeries, animate: boolean = false): void {
    if (this.chart) {
      this.chart.updateSeries(newSeries, animate);
    }
  }

  // Computed chart options with defaults
  computedChartOptions = computed<ApexChart>(() => {
    const options = this.chartOptions();
    return {
      height: this.height(),
      type: 'pie',
      ...options.chart,
    };
  });

  computedLabels = computed<string[]>(() => {
    const options = this.chartOptions();
    return options.labels || [];
  });

  computedDataLabelsOptions = computed<ApexDataLabels>(() => {
    const options = this.chartOptions();
    return {
      enabled: true,
      ...options.dataLabels,
    };
  });

  computedTitleOptions = computed<ApexTitleSubtitle>(() => {
    const options = this.chartOptions();
    return {
      text: '',
      align: 'left',
      ...options.title,
    };
  });

  computedLegendOptions = computed<ApexLegend>(() => {
    const options = this.chartOptions();
    return {
      position: 'bottom',
      horizontalAlign: 'center',
      ...options.legend,
    };
  });

  computedColors = computed<string[]>(() => {
    const options = this.chartOptions();
    return options.colors || ['#2E93fA', '#66DA26', '#546E7A', '#E91E63', '#FF9800'];
  });

  computedPlotOptions = computed<ApexPlotOptions>(() => {
    const options = this.chartOptions();
    return {
      pie: {
        donut: {
          labels: {
            show: false,
          },
        },
      },
      ...options.plotOptions,
    };
  });

  computedResponsive = computed<ApexResponsive[]>(() => {
    const options = this.chartOptions();
    return options.responsive || [];
  });
}
