import { Component, OnInit } from '@angular/core';
import { MatButton } from '@angular/material/button';
import { NgIf, NgOptimizedImage } from '@angular/common';
import { UserFormResultsComponent } from '@components/user-form-results/user-form-results.component';
import { USER_FORM_ID } from '../home.component';
import { Router } from '@angular/router';
import { FormService } from '@services/form.service';
import { AnsweredForm } from '../../../types';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { SubjectService } from '@services/subject.service';
import * as echarts from 'echarts';
import 'echarts-wordcloud';
import { Chart, registerables } from 'chart.js';

@Component({
  selector: 'app-user-home',
  standalone: true,
  imports: [MatButton, NgIf, NgOptimizedImage, UserFormResultsComponent, NgxSkeletonLoaderModule],
  templateUrl: './user-home.component.html',
  styleUrl: './user-home.component.scss',
})
export class UserHomeComponent implements OnInit {
  loading = true;
  formData: AnsweredForm | undefined;

  constructor(
    private router: Router,
    private formService: FormService,
    private subjectService: SubjectService
  ) {
    Chart.register(...registerables);
  }

  ngOnInit() {
    this.formService.getExistingFormAnswers(USER_FORM_ID).subscribe({
      next: (data: AnsweredForm) => {
        this.formData = data;
        this.loading = false;
      },
      error: () => {
        this.loading = false;
      },
    });

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
        chart.setOption(options);
      }
    });

    this.subjectService.getCategorySums().subscribe({
      next: (data) => {
        const totalSum = data.reduce((sum, item) => sum + item.totalSum, 0);

        // Calculate percentages
        const labels = data.map((item) => item.focusCategory);
        const percentages = data.map((item) => ((item.totalSum / totalSum) * 100).toFixed(2));

        // Chart.js configuration
        const ctx = document.getElementById('pieChart') as HTMLCanvasElement;
        new Chart(ctx, {
          type: 'pie',
          data: {
            labels: labels,
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
    })
  }

  redirectToUserForm() {
    this.router.navigate(['/grade-form']);
  }
}
