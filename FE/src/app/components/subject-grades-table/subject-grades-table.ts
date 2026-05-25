import { Component, input, ViewChild, AfterViewInit, effect } from '@angular/core';
import {
  MatTable,
  MatTableDataSource,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatCell,
  MatCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
} from '@angular/material/table';
import { MatPaginator } from '@angular/material/paginator';
import { MatIcon } from '@angular/material/icon';
import { NgClass } from '@angular/common';
import { GradeClassPipe } from './grade-class.pipe';

export interface SubjectGrade {
  subjectName: string;
  grade: string;
  credits?: number;
}

@Component({
  selector: 'app-subject-grades-table',
  standalone: true,
  imports: [
    NgClass,
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatHeaderCellDef,
    MatCell,
    MatCellDef,
    MatHeaderRow,
    MatHeaderRowDef,
    MatRow,
    MatRowDef,
    MatPaginator,
    MatIcon,
    GradeClassPipe,
  ],
  styleUrl: './subject-grades-table.scss',
  templateUrl: './subject-grades-table.html',
})
export class SubjectGradesTable implements AfterViewInit {
  // Input signals
  data = input<SubjectGrade[]>([]);
  pageSize = input<number>(5);
  pageSizeOptions = input<number[]>([5, 10, 20]);

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  dataSource: MatTableDataSource<SubjectGrade> = new MatTableDataSource();
  displayedColumns: string[] = ['nazovPredmetu', 'znamka'];

  constructor() {
    // Use effect to update dataSource when data signal changes
    effect(() => {
      this.dataSource.data = this.data();
    });
  }

  ngAfterViewInit(): void {
    this.dataSource.paginator = this.paginator;
  }

  applyFilter(event: Event): void {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }
}
