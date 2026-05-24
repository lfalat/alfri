import {
  AfterViewInit,
  Component,
  ElementRef,
  input,
  OnChanges,
  OnDestroy,
  SimpleChanges,
  ViewChild,
} from '@angular/core';
import {
  Chart as chartJs,
  Chart,
  ChartConfiguration,
  Filler,
  Legend,
  LineElement,
  LinearScale,
  PointElement,
  RadarController,
  RadialLinearScale,
  Title,
  Tooltip,
} from 'chart.js';

export interface RadarChartData {
  labels: string[];
  data: number[];
  label?: string;
}

export interface RadarChartOptions {
  data: RadarChartData;
  title?: string;
  colors?: {
    borderColor?: string;
    backgroundColor?: string | CanvasGradient;
    pointBackgroundColor?: string;
    pointBorderColor?: string;
    pointHoverBackgroundColor?: string;
    pointHoverBorderColor?: string;
  };
  scales?: {
    suggestedMin?: number;
    suggestedMax?: number;
    stepSize?: number;
    angleLineColor?: string;
    gridColor?: string;
    pointLabelColor?: string;
    pointLabelFontSize?: number;
    showTicks?: boolean;
  };
  legend?: {
    display?: boolean;
  };
  responsive?: boolean;
  maintainAspectRatio?: boolean;
}

@Component({
  selector: 'app-radar-chart',
  standalone: true,
  template: `
    <div class="radar-chart-wrapper">
      <canvas #radarChart></canvas>
    </div>
  `,
  styles: [
    `
      .radar-chart-wrapper {
        position: relative;
        width: 100%;
        height: 100%;
      }
    `,
  ],
})
export class RadarChartComponent implements AfterViewInit, OnChanges, OnDestroy {
  @ViewChild('radarChart', { static: false }) chartCanvas!: ElementRef<HTMLCanvasElement>;

  // Input for chart options
  options = input.required<RadarChartOptions>();

  private chart: Chart | null = null;

  constructor() {
    // Register Chart.js components
    chartJs.register(
      LinearScale,
      PointElement,
      LineElement,
      RadialLinearScale,
      RadarController,
      Filler,
      Title,
      Tooltip,
      Legend,
    );
  }

  ngAfterViewInit(): void {
    this.initializeChart();
  }

  ngOnChanges(changes: SimpleChanges): void {
    // Update chart when options change
    if (changes['options'] && !changes['options'].firstChange && this.chart) {
      this.updateChart();
    }
  }

  ngOnDestroy(): void {
    if (this.chart) {
      this.chart.destroy();
    }
  }

  private initializeChart(): void {
    const canvas = this.chartCanvas.nativeElement;
    const ctx = canvas.getContext('2d');

    if (!ctx) {
      console.error('Failed to get 2D context for radar chart');
      return;
    }

    const chartOptions = this.options();
    const colors = this.getColors(ctx, chartOptions);
    const scaleOptions = this.getScaleOptions(chartOptions);

    const config: ChartConfiguration<'radar'> = {
      type: 'radar',
      data: {
        labels: chartOptions.data.labels,
        datasets: [
          {
            label: chartOptions.data.label || 'Data',
            data: chartOptions.data.data,
            fill: true,
            backgroundColor: colors.backgroundColor,
            borderColor: colors.borderColor,
            pointBackgroundColor: colors.pointBackgroundColor,
            pointBorderColor: colors.pointBorderColor,
            pointHoverBackgroundColor: colors.pointHoverBackgroundColor,
            pointHoverBorderColor: colors.pointHoverBorderColor,
            borderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 7,
          },
        ],
      },
      options: {
        responsive: chartOptions.responsive ?? true,
        maintainAspectRatio: chartOptions.maintainAspectRatio ?? false,
        scales: {
          r: {
            angleLines: {
              display: true,
              color: scaleOptions.angleLineColor,
            },
            grid: {
              color: scaleOptions.gridColor,
            },
            pointLabels: {
              color: scaleOptions.pointLabelColor,
              font: {
                size: scaleOptions.pointLabelFontSize,
                family: "'Plus Jakarta Sans', sans-serif",
                weight: 600,
              },
            },
            ticks: {
              display: scaleOptions.showTicks,
              stepSize: scaleOptions.stepSize,
              backdropColor: 'transparent',
            },
            suggestedMin: scaleOptions.suggestedMin,
            suggestedMax: scaleOptions.suggestedMax,
          },
        },
        plugins: {
          tooltip: {
            backgroundColor: '#0f172a',
            titleColor: '#f0f9ff',
            bodyColor: '#e2e8f0',
            padding: 12,
            cornerRadius: 12,
            displayColors: false,
            titleFont: {
              family: "'Plus Jakarta Sans', sans-serif",
              size: 14,
            },
            bodyFont: {
              family: "'Plus Jakarta Sans', sans-serif",
              size: 13,
            },
            callbacks: {
              label: (context) => {
                const value = context.raw || 0;
                return `${chartOptions.data.label || 'Value'}: ${String(value)}`;
              },
            },
          },
          legend: {
            display: chartOptions.legend?.display ?? false,
          },
        },
      },
    };

    this.chart = new Chart(ctx, config);
  }

  private updateChart(): void {
    if (!this.chart) return;

    const chartOptions = this.options();
    this.chart.data.labels = chartOptions.data.labels;

    const dataset = this.chart.data.datasets[0];
    dataset.data = chartOptions.data.data;
    dataset.label = chartOptions.data.label || 'Data';

    // Update colors if needed
    const ctx = this.chartCanvas.nativeElement.getContext('2d');
    if (ctx) {
      const colors = this.getColors(ctx, chartOptions);
      dataset.backgroundColor = colors.backgroundColor;
      dataset.borderColor = colors.borderColor;
      dataset.backgroundColor = colors.pointBackgroundColor;
      dataset.borderColor = colors.pointBorderColor;
      dataset.hoverBackgroundColor = colors.pointHoverBackgroundColor;
      dataset.hoverBackgroundColor = colors.pointHoverBorderColor;
    }

    this.chart.update();
  }

  private getColors(ctx: CanvasRenderingContext2D, chartOptions: RadarChartOptions) {
    let backgroundColor: string | CanvasGradient;

    if (chartOptions.colors?.backgroundColor) {
      backgroundColor = chartOptions.colors.backgroundColor;
    } else {
      // Create default gradient
      const gradient = ctx.createRadialGradient(0, 0, 0, 0, 0, 400);
      gradient.addColorStop(0, 'rgba(14, 116, 144, 0.4)');
      gradient.addColorStop(1, 'rgba(6, 182, 212, 0.05)');
      backgroundColor = gradient;
    }

    return {
      backgroundColor,
      borderColor: chartOptions.colors?.borderColor || '#f97316',
      pointBackgroundColor: chartOptions.colors?.pointBackgroundColor || '#fff',
      pointBorderColor: chartOptions.colors?.pointBorderColor || '#f97316',
      pointHoverBackgroundColor: chartOptions.colors?.pointHoverBackgroundColor || '#f97316',
      pointHoverBorderColor: chartOptions.colors?.pointHoverBorderColor || '#fff',
    };
  }

  private getScaleOptions(chartOptions: RadarChartOptions) {
    const scales = chartOptions.scales || {};
    return {
      suggestedMin: scales.suggestedMin ?? 0,
      suggestedMax: scales.suggestedMax ?? 10,
      stepSize: scales.stepSize ?? 2,
      angleLineColor: scales.angleLineColor || 'rgba(14, 116, 144, 0.1)',
      gridColor: scales.gridColor || 'rgba(14, 116, 144, 0.1)',
      pointLabelColor: scales.pointLabelColor || '#475569',
      pointLabelFontSize: scales.pointLabelFontSize ?? 12,
      showTicks: scales.showTicks ?? false,
    };
  }
}
