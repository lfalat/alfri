import { ApexOptions, ApexAxisChartSeries } from 'ng-apexcharts';
import { StudentTrendDataPoint, AverageGradeDataPoint, GradeDistribution } from '../../../types';

export function getStudentTrendChartOptions(
  trendData: StudentTrendDataPoint[],
  series: ApexAxisChartSeries,
): ApexOptions {
  return {
    series: series,
    chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false,
      },
      toolbar: {
        show: true,
      },
      animations: {
        enabled: true,
        animateGradually: {
          enabled: true,
          delay: 150,
        },
        dynamicAnimation: {
          enabled: false,
        },
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: 'smooth' as const,
      width: 3,
    },
    grid: {
      row: {
        colors: ['#f3f3f3', 'transparent'],
        opacity: 0.5,
      },
    },
    xaxis: {
      categories: trendData.map((d) => d.year.toString()),
      title: {
        text: 'Rok',
      },
    },
    yaxis: {
      title: {
        text: 'Počet študentov',
      },
    },
    legend: {
      position: 'top',
      horizontalAlign: 'right',
    },
    colors: ['#2E93fA', '#FF9800'],
  };
}

export function getGradeChartOptions(gradeData: AverageGradeDataPoint[]): ApexOptions {
  return {
    series: [
      {
        name: '1. ročník',
        data: gradeData.map((d) => d.year1),
      },
      {
        name: '2. ročník',
        data: gradeData.map((d) => d.year2),
      },
      {
        name: '3. ročník',
        data: gradeData.map((d) => d.year3),
      },
      {
        name: '4. ročník',
        data: gradeData.map((d) => d.year4),
      },
      {
        name: '5. ročník',
        data: gradeData.map((d) => d.year5),
      },
    ],
    chart: {
      height: 350,
      type: 'line',
      zoom: {
        enabled: false,
      },
      toolbar: {
        show: true,
      },
      animations: {
        enabled: true,
        animateGradually: {
          enabled: true,
          delay: 150,
        },
        dynamicAnimation: {
          enabled: false,
        },
      },
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: 'smooth' as const,
      width: 3,
    },
    grid: {
      row: {
        colors: ['#f3f3f3', 'transparent'],
        opacity: 0.5,
      },
    },
    xaxis: {
      categories: gradeData.map((d) => d.academicYear.toString()),
      title: {
        text: 'Akademický rok',
      },
    },
    yaxis: {
      title: {
        text: 'Priemerná známka',
      },
      reversed: true,
      min: 1,
      max: 4,
      decimalsInFloat: 2,
    },
    legend: {
      position: 'top',
      horizontalAlign: 'right',
    },
    colors: ['#2E93fA', '#66DA26', '#546E7A', '#E91E63', '#FF9800'],
  };
}

export function getGradeDistributionChartOptions(
  gradeDistribution: GradeDistribution[],
): ApexOptions {
  return {
    series: gradeDistribution.map((d) => d.count),
    chart: {
      type: 'pie',
      height: 350,
    },
    labels: gradeDistribution.map((d) => `Známka ${d.grade}`),
    legend: {
      position: 'bottom',
      horizontalAlign: 'center',
    },
    colors: ['#00E396', '#00D9F5', '#FEB019', '#FF4560', '#775DD0', '#3F51B5'],
    dataLabels: {
      enabled: true,
      formatter: function (val: number) {
        return `${val.toFixed(1)}%`;
      },
    },
    tooltip: {
      y: {
        formatter: function (val: number) {
          return `${val} študentov`;
        },
      },
    },
    responsive: [
      {
        breakpoint: 480,
        options: {
          chart: {
            width: 300,
          },
          legend: {
            position: 'bottom',
          },
        },
      },
    ],
  };
}
