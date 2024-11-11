import { Component, OnInit, ViewChild } from '@angular/core';
import { Chart, ChartConfiguration, ChartType, registerables } from 'chart.js';
import { FormsModule } from '@angular/forms';
import { BaseChartDirective } from 'ng2-charts';
import { NgForOf } from '@angular/common';
import { AverageGradeService } from '../services/average-grade.service';

Chart.register(...registerables);

@Component({
  selector: 'app-average-grade-analysis',
  standalone: true,
  imports: [
    FormsModule,
    BaseChartDirective,
    NgForOf
  ],
  templateUrl: './average-grade-analysis.component.html',
  styleUrls: ['./average-grade-analysis.component.scss']
})
export class AverageGradeAnalysisComponent implements OnInit {
  studyPrograms = ['informatika', 'informatika a riadenie', 'manazment'];
  selectedProgram = this.studyPrograms[0];

  @ViewChild(BaseChartDirective) chart: BaseChartDirective | undefined;

  lineChartData: ChartConfiguration['data'] = {
    datasets: [
      {
        data: [], // Average grades data
        label: 'Priemerná známka v programe ' + this.selectedProgram,
        borderColor: 'rgba(75,192,192,1)',
        backgroundColor: 'rgba(75,192,192,0.2)',
      }
    ],
    labels: [] as string[] // Years
  };

  lineChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    scales: {
      x: {},
      y: {
        beginAtZero: true,
        max: 5
      }
    }
  };
  lineChartType: ChartType = 'line';

  constructor(private averageGradeService: AverageGradeService) {}

  ngOnInit() {
    this.fetchData();
  }

  fetchData() {

    this.lineChartData.datasets[0].label = 'Priemerná známka v programe ' + this.selectedProgram;

    this.averageGradeService.getAverageGradesByProgram(this.selectedProgram).subscribe({
      next: (data) => {
        this.lineChartData.labels = data.map((item) => item.year.toString());
        this.lineChartData.datasets[0].data = data.map((item) => item.averageGrade);

        // if (this.chart) {
        //   this.chart.chart.update();
        // }
      },
      error: (err) => {
        console.error('Error fetching data:', err);
      }
    });
  }

  onProgramChange() {
    this.fetchData();
  }
}
