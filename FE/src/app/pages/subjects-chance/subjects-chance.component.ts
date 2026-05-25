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
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatProgressBar } from '@angular/material/progress-bar';
import { animate, style, transition, trigger } from '@angular/animations';
import { MatTooltip } from '@angular/material/tooltip';
import { Page, SubjectDto } from '../../types';

export interface Subject {
  subjectName: string;
  subjectChance: number;
}

const SUBJECT_DATA: Subject[] = [
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
  { subjectName: 'Math', subjectChance: Math.random() * 100 },
  { subjectName: 'Science', subjectChance: Math.random() * 100 },
  { subjectName: 'History', subjectChance: Math.random() * 100 },
  { subjectName: 'Geography', subjectChance: Math.random() * 100 },
  { subjectName: 'Physics', subjectChance: Math.random() * 100 },
];

@Component({
  selector: 'app-subjects-chance',
  standalone: true,
  imports: [
    MatTable,
    MatHeaderCell,
    MatColumnDef,
    MatHeaderCellDef,
    MatCell,
    MatHeaderRow,
    MatRow,
    MatPaginator,
    MatCellDef,
    MatHeaderRowDef,
    MatRowDef,
    MatTooltip,
  ],
  templateUrl: './subjects-chance.component.html',
  styleUrl: './subjects-chance.component.scss',
  animations: [
    trigger('animateProgressBar', [
      transition(':enter', [
        style({ width: '0%' }),
        animate('1s ease-out', style({ width: '{{progress}}%' })),
      ]),
    ]),
  ],
})
export class SubjectsChanceComponent implements OnInit {
  displayedColumns: string[] = ['subjectName', 'subjectChance'];
  dataSource = new MatTableDataSource<Subject>(SUBJECT_DATA);

  @ViewChild(MatPaginator) paginator!: MatPaginator;

  public readonly pageData: Page<SubjectDto> = {
    content: [],
    totalElements: SUBJECT_DATA.length,
    size: 10,
    number: 0,
    pageable: {
      sort: {
        sorted: false,
        unsorted: false,
        empty: false,
      },
      offset: 0,
      pageNumber: 0,
      pageSize: 0,
      paged: false,
      unpaged: false,
    },
    last: false,
    totalPages: 0,
    sort: {
      sorted: false,
      unsorted: false,
      empty: false,
    },
    first: false,
    numberOfElements: 0,
    empty: false,
  };

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
  }

  getProgressValue(subjectChance: number): string {
    return subjectChance.toString();
  }
  public onPageChange($event: PageEvent) {
    // this.isLoading = true;
    //
    // this.dataSource = this.getSubjects(
    //   $event.pageIndex,
    //   $event.pageSize,
    //   this._selectedStudyProgramId
    // );
  }

  protected readonly Math = Math;
}
