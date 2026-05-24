import {
  Component,
  computed,
  effect,
  ElementRef,
  inject,
  OnDestroy,
  OnInit,
  signal,
  ViewChild,
} from '@angular/core';

import { MatCardModule } from '@angular/material/card';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { FormsModule } from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';
import { DataReportService } from '@services/data-report.service';
import { StudyProgramService } from '@services/study-program.service';
import {
  DataReportDto,
  StudentTrendDataPoint,
  StudyProgramDto,
  StudyProgramId,
} from '../../../types';
import { LineChartComponent, PieChartComponent } from '@components/charts';
import { ApexAxisChartSeries, ApexOptions } from 'ng-apexcharts';
import { INFORMATICS_STUDY_PROGRAM_ID, MANAGEMENT_STUDY_PROGRAM_ID } from '../../../const';
import {
  getStudentTrendChartOptions,
  getGradeChartOptions,
  getGradeDistributionChartOptions,
} from './teacher-home.const';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';

@Component({
  selector: 'app-teacher-home',
  standalone: true,
  imports: [
    MatCardModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatSelectModule,
    MatFormFieldModule,
    MatIconModule,
    MatButtonModule,
    FormsModule,
    LineChartComponent,
    PieChartComponent,
  ],
  templateUrl: './teacher-home.component.html',
  styleUrl: './teacher-home.component.scss',
})
export class TeacherHomeComponent implements OnInit, OnDestroy {
  @ViewChild(LineChartComponent) lineChart?: LineChartComponent;
  @ViewChild('reportContent') reportContent?: ElementRef;

  private readonly _destroy$: Subject<void> = new Subject();
  private readonly dataReportService = inject(DataReportService);
  private readonly studyProgramService = inject(StudyProgramService);

  // Signals
  isLoading = signal(false);
  isExporting = signal(false);
  dataReport = signal<DataReportDto | null>(null);
  selectedStudyProgramId = signal<StudyProgramId | null>(null);
  studyPrograms = signal<StudyProgramDto[]>([]);

  // Computed properties
  chartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report) {
      return null;
    }

    const trendData = report.studentTrend;
    const series = this.getSeriesData(trendData);

    return getStudentTrendChartOptions(trendData, series);
  });

  showStudyProgramCount = computed(() => this.selectedStudyProgramId() === null);

  gradeChartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report?.averageGradeByYear) return null;

    return getGradeChartOptions(report.averageGradeByYear);
  });

  gradeDistributionChartOptions = computed<ApexOptions | null>(() => {
    const report = this.dataReport();
    if (!report?.gradeDistribution) return null;

    return getGradeDistributionChartOptions(report.gradeDistribution);
  });

  constructor() {
    // Effect to watch selectedStudyProgramId changes and fetch data
    effect(() => {
      const studyProgramId = this.selectedStudyProgramId();
      // Skip initial load (handled by ngOnInit)
      if (this.studyPrograms().length > 0) {
        this.fetchDataReport(studyProgramId);
      }
    });
  }

  ngOnInit(): void {
    this.loadData();
  }

  ngOnDestroy(): void {
    this._destroy$.next();
    this._destroy$.complete();
  }

  loadData(): void {
    this.isLoading.set(true);
    // First load study programs, then fetch data report
    this.studyProgramService
      .getAll()
      .pipe(takeUntil(this._destroy$))
      .subscribe({
        next: (studyPrograms) => {
          this.studyPrograms.set(studyPrograms);
          this.fetchDataReport(this.selectedStudyProgramId());
        },
        error: () => {
          this.isLoading.set(false);
        },
      });
  }

  private fetchDataReport(studyProgramId: StudyProgramId | null): void {
    this.isLoading.set(true);
    this.dataReportService
      .getDataReport(studyProgramId)
      .pipe(takeUntil(this._destroy$))
      .subscribe({
        next: (dataReport) => {
          this.dataReport.set(dataReport);
          this.isLoading.set(false);
        },
        error: () => {
          this.isLoading.set(false);
        },
      });
  }

  getSeriesData(trendData: StudentTrendDataPoint[]): ApexAxisChartSeries {
    let series: ApexAxisChartSeries = [];

    // If a specific study program is selected, show only that program's data
    const selectedId = this.selectedStudyProgramId();
    if (selectedId) {
      console.log(selectedId, this.studyPrograms());
      const selectedProgram = this.studyPrograms().find((p) => p.id === selectedId);
      if (selectedProgram) {
        series = [
          {
            name: selectedProgram.name,
            data: trendData.map((d: StudentTrendDataPoint) => d.programCounts[selectedId]),
          },
        ];
      }
    } else {
      console.log(trendData);
      // Show all programs
      series = [
        {
          name: 'Informatika',
          data: trendData.map((d) => d.programCounts[INFORMATICS_STUDY_PROGRAM_ID]),
        },
        {
          name: 'Manažment',
          data: trendData.map((d) => d.programCounts[MANAGEMENT_STUDY_PROGRAM_ID]),
        },
      ];
    }

    return series;
  }

  async exportToPdf(): Promise<void> {
    if (!this.reportContent) {
      return;
    }

    this.isExporting.set(true);

    // Add a small delay to allow the UI to update and show the spinner
    await new Promise((resolve) => setTimeout(resolve, 100));

    try {
      const element = this.reportContent.nativeElement;

      // Use html2canvas to capture the content
      const canvas = await html2canvas(element, {
        scale: 2,
        useCORS: true,
        logging: false,
        backgroundColor: '#ffffff',
      });

      const imgData = canvas.toDataURL('image/png');

      // Calculate PDF dimensions
      const imgWidth = 210; // A4 width in mm
      const pageHeight = 297; // A4 height in mm
      const imgHeight = (canvas.height * imgWidth) / canvas.width;

      const pdf = new jsPDF('p', 'mm', 'a4');
      let heightLeft = imgHeight;
      let position = 0;

      // Add first page
      pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
      heightLeft -= pageHeight;

      // Add additional pages if content is longer than one page
      while (heightLeft > 0) {
        position = heightLeft - imgHeight;
        pdf.addPage();
        pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
      }

      // Get study program name for filename
      const selectedId = this.selectedStudyProgramId();
      let filename = 'report-udajov';

      if (selectedId) {
        const selectedProgram = this.studyPrograms().find((p) => p.id === selectedId);
        if (selectedProgram) {
          filename = `report-udajov-${selectedProgram.name.toLowerCase().replace(/\s+/g, '-')}`;
        }
      }

      // Save the PDF
      pdf.save(`${filename}-${new Date().toISOString().split('T')[0]}.pdf`);
    } catch (error) {
      console.error('Error generating PDF:', error);
    } finally {
      this.isExporting.set(false);
    }
  }
}
