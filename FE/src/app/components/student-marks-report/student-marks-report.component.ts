import { Component, OnInit, ViewChild } from '@angular/core';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
  MatTableDataSource,
} from '@angular/material/table';
import { MatMenu, MatMenuItem, MatMenuTrigger } from '@angular/material/menu';

import { MatButton } from '@angular/material/button';
import { MatIcon } from '@angular/material/icon';
import {
  MatChip,
  MatChipListbox,
  MatChipRemove,
} from '@angular/material/chips';
import { LeadService } from '@services/lead.service';
import { StudentAverageGradeDTO, StudentFilterDTO } from '../../types';
import { MatProgressBar } from '@angular/material/progress-bar';
import {
  animate,
  state,
  style,
  transition,
  trigger,
} from '@angular/animations';
import { NotificationService } from '@services/notification.service';
import * as Papa from 'papaparse';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { debounceTime, Subject } from 'rxjs';

@Component({
  selector: 'app-student-marks-report',
  standalone: true,
  imports: [
    MatRow,
    MatHeaderRow,
    MatHeaderRowDef,
    MatRowDef,
    MatCellDef,
    MatCell,
    MatMenuItem,
    MatMenu,
    MatButton,
    MatHeaderCell,
    MatHeaderCellDef,
    MatMenuTrigger,
    MatColumnDef,
    MatTable,
    MatIcon,
    MatChipRemove,
    MatChip,
    MatChipListbox,
    MatProgressBar,
    MatPaginator,
  ],
  animations: [
    trigger('fadeInOut', [
      state(
        'void',
        style({
          opacity: 0,
          height: 0,
        }),
      ),
      transition('void <=> *', animate('200ms ease-in-out')),
    ]),
    trigger('buttonOpacityChange', [
      state('enabled', style({ opacity: 1 })),
      state('disabled', style({ opacity: 0.5 })),
      transition('enabled <=> disabled', animate('300ms ease-in-out')),
    ]),
  ],
  templateUrl: './student-marks-report.component.html',
  styleUrl: './student-marks-report.component.scss',
})
export class StudentMarksReportComponent implements OnInit {
  @ViewChild(MatPaginator) paginator!: MatPaginator;
  pageSizeOptions: readonly number[] = [25, 100, 250, 500, 1000];
  isLoadingSubject = new Subject<boolean>();
  filter: StudentFilterDTO = {
    page: 0,
    size: 10,
    sortBy: 'avgMark',
    direction: 'ASC',
    year: undefined,
    studyProgramId: undefined,
  };

  dataSource = new MatTableDataSource<StudentAverageGradeDTO>([]);
  displayedColumns: string[] = ['id', 'studyProgram', 'year', 'avgMark'];
  filterOptionsStudyProgram: { name: string; value: number }[] = [
    { name: 'Informatika', value: 3 },
    { name: 'Manažment', value: 4 },
  ];
  filterOptionsYear: number[] = [1, 2, 3, 4, 5];
  selectedFilterStudyProgram: { name: string; value: number } | null = null;
  selectedFilterYear: number | null = null;
  isLoading: boolean = false;

  constructor(
    private readonly leadService: LeadService,
    private readonly notificationService: NotificationService,
  ) {
    this.isLoadingSubject.pipe(debounceTime(200)).subscribe((value) => {
      this.isLoading = value;
    });
  }

  setLoading(state: boolean) {
    this.isLoadingSubject.next(state);
  }

  ngOnInit(): void {
    this.fetchData();
  }

  onPageChange(event: PageEvent) {
    this.filter.page = event.pageIndex;
    this.filter.size = event.pageSize;
    this.fetchData();
  }

  // Apply study program filter
  applyStudyProgramFilter(option: { name: string; value: number }) {
    this.selectedFilterStudyProgram = option;
    this.filter.studyProgramId = option.value;
    this.fetchData();
  }

  // Apply year filter
  applyYearFilter(option: number) {
    this.selectedFilterYear = option;
    this.filter.year = option;
    this.fetchData();
  }

  // Clear study program filter
  clearStudyProgramFilter() {
    this.selectedFilterStudyProgram = null;
    this.filter.studyProgramId = undefined;
    this.fetchData();
  }

  // Clear year filter
  clearYearFilter() {
    this.selectedFilterYear = null;
    this.filter.year = undefined;
    this.fetchData();
  }

  // Fetch data from the server
  fetchData() {
    this.isLoading = true;
    this.leadService.getStudentPerformanceReport(this.filter).subscribe({
      next: (data) => {
        this.dataSource.data = data.content;
        this.setLoading(false);

        if (this.paginator) {
          this.paginator.length = data.totalElements;
          this.paginator.pageIndex = data.number;
          this.paginator.pageSize = this.filter.size;
        }
      },
      error: (error) => {
        console.error(error);
        this.setLoading(false);
      },
    });
  }

  sortByAvgMark() {
    if (this.filter.sortBy === 'avgMark') {
      this.filter.direction = this.filter.direction === 'ASC' ? 'DESC' : 'ASC';
    } else {
      this.filter.sortBy = 'avgMark';
      this.filter.direction = 'ASC';
    }
    this.fetchData();
  }

  // Method to export data to CSV
  exportToCsv() {
    if (this.dataSource.data.length === 0) {
      this.notificationService.showError(
        'Žiadne dáta na exportovanie.',
        'Zavrieť',
      );
      return;
    }

    const csv = Papa.unparse(this.dataSource.data, {
      header: true,
      delimiter: ',',
      quotes: true,
    });

    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'student_marks_report.csv';
    link.click();

    URL.revokeObjectURL(link.href);
  }
}
