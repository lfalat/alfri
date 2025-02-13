import { Component, OnInit } from '@angular/core';
import { SubjectService } from '@services/subject.service';
import { Chart, registerables } from 'chart.js';
import 'echarts-wordcloud';
import * as echarts from 'echarts';
import { StudentYearCountDTO } from '../../../types';

@Component({
  selector: 'app-vedenie-home',
  standalone: true,
  imports: [],
  templateUrl: './vedenie-home.component.html',
  styleUrl: './vedenie-home.component.scss'
})
export class VedenieHomeComponent implements OnInit {

  constructor(
    private subjectService: SubjectService
  ) {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.subjectService.getAllKeywords().subscribe({
      next: (data) => {
        const chart = echarts.init(document.getElementById('wordcloud-chart') as HTMLDivElement);

        // Transform your data into the format expected by ECharts
        const wordCloudData = data.map(item => ({
          name: item.keyword,
          value: item.count,
        }));

        // Chart options
        const options: echarts.EChartsOption = {
          series: [
            {
              type: 'wordCloud',
              shape: 'circle',
              sizeRange: [12, 60], // Range of font sizes
              rotationRange: [-90, 90], // Range of rotation angles
              rotationStep: 45,
              gridSize: 8,
              drawOutOfBound: false,
              layoutAnimation: true,
              textStyle: {
                fontFamily: 'sans-serif',
                fontWeight: 'bold',
                color: () => {
                  // Random color for each word
                  return (
                    'rgb(' +
                    [
                      Math.round(Math.random() * 160),
                      Math.round(Math.random() * 160),
                      Math.round(Math.random() * 160),
                    ].join(',') +
                    ')'
                  );
                },
              },
              emphasis: {
                focus: 'self',
              },
              data: wordCloudData, // Use the transformed data
            },
          ],
        };

        // Set options and render the chart
        console.log(options)
        chart.setOption(options);
      }
    });

    this.subjectService.getCategorySums().subscribe({
      next: (data) => {
        const totalSum = data.reduce((sum, item) => sum + item.totalSum, 0);

        const focusLabelMapping: { [key: string]: string } = {
          math_focus: 'Matematika',
          logic_focus: 'Logika',
          programming_focus: 'Programovanie',
          design_focus: 'Dizajn',
          economics_focus: 'Ekonomika',
          management_focus: 'Manažment',
          hardware_focus: 'Hardvér',
          network_focus: 'Sieťové technológie',
          data_focus: 'Práca s dátami',
          testing_focus: 'Testovanie',
          language_focus: 'Jazyky',
          physical_focus: 'Fyzické zameranie',
        };
        // Calculate percentages
        const labels = data.map((item) => item.focusCategory);

        const percentages = data.map((item) => ((item.totalSum / totalSum) * 100).toFixed(2));

        // Chart.js configuration
        const ctx = document.getElementById('pieChart') as HTMLCanvasElement;
        new Chart(ctx, {
          type: 'pie',
          data: {
            labels: labels.map((key) => {
              return focusLabelMapping[key];
            }),
            datasets: [
              {
                data: percentages,
                backgroundColor: [
                  '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF',
                  '#FF9F40', '#E7E9ED', '#8C9EFF', '#00CC99', '#FF6666',
                  '#CC99FF', '#66FF66',
                ],
              },
            ],
          },
          options: {
            responsive: true,
            plugins: {
              tooltip: {
                callbacks: {
                  label: (context) => {
                    const label = context.label || '';
                    const value = context.raw || '';
                    return `${label}: ${value}%`;
                  },
                },
              },
              legend: {
                position: 'bottom',
              },
            },
          },
        });
      }
    });

    // Call the new service for student counts by year
    this.subjectService.getStudentCountsByYear().subscribe({
      next: (data: StudentYearCountDTO[]) => {
        // Extract years and counts from the data
        const years = data.map((item) => item.year.toString());
        const counts = data.map((item) => item.studentsCount);

        // Render the bar chart
        const ctx = document.getElementById('barChart') as HTMLCanvasElement;
        new Chart(ctx, {
          type: 'bar',
          data: {
            labels: years,
            datasets: [
              {
                label: 'Počet študentov',
                data: counts,
                backgroundColor: '#36A2EB',
                borderColor: '#36A2EB',
                borderWidth: 1,
              },
            ],
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                display: true,
                position: 'top',
              },
              tooltip: {
                callbacks: {
                  label: (context) => {
                    const label = context.dataset.label || '';
                    const value = context.raw || '';
                    return `${label}: ${value}`;
                  },
                },
              },
            },
            scales: {
              y: {
                beginAtZero: true,
                title: {
                  display: true,
                  text: 'Počet študentov',
                },
              },
              x: {
                title: {
                  display: true,
                  text: 'Rok',
                },
              },
            },
          },
        });
      },
      error: (error) => {
        console.error('Error fetching student counts by year:', error);
      },
    });
  }
}
