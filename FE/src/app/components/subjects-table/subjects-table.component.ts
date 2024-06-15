import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Observable } from 'rxjs';
import { Page, SubjectDto } from '../../types';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
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
  MatTable
} from '@angular/material/table';
import { MatProgressBar } from '@angular/material/progress-bar';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-subjects-table',
  standalone: true,
  imports: [
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatCell,
    MatHeaderRow,
    MatRow,
    MatProgressBar,
    MatPaginator,
    MatHeaderCellDef,
    MatCellDef,
    MatHeaderRowDef,
    MatRowDef,
    NgIf
  ],
  templateUrl: './subjects-table.component.html',
  styleUrl: './subjects-table.component.scss'
})
export class SubjectsTableComponent {
  @Input() dataSource$!: Observable<SubjectDto[]>;
  @Input() pageData!: Page<SubjectDto>;
  @Input() isLoading = false;

  @Output() pageChange = new EventEmitter<PageEvent>();
  @Output() subjectDetailNavigate = new EventEmitter<string>();

  public readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'abbreviation',
    'obligation',
    'recommendedYear',
    'semester',
  ];

  onPageChange(event: PageEvent) {
    this.pageChange.emit(event);
  }

  navigateToSubjectDetail(code: string) {
    this.subjectDetailNavigate.emit(code);
  }
}
