import { Component, inject, OnDestroy, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { catchError, of, Subject, takeUntil, tap } from 'rxjs';
import { Router } from '@angular/router';
import { PageEvent } from '@angular/material/paginator';
import { SortDirection } from '@angular/material/sort';
import { MatCard, MatCardContent } from '@angular/material/card';
import { Page, PopularSubjectRow } from '../../types';
import { SubjectService } from '@services/subject.service';
import {
  GenericTableComponent,
  TableConfig,
  TextCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';

@Component({
  selector: 'app-popular-subjects',
  standalone: true,
  imports: [
    CommonModule,
    GenericTableComponent,
    MatCard,
    MatCardContent,
  ],
  templateUrl: './popular-subjects.component.html',
  styleUrls: ['./popular-subjects.component.scss'],
})
export class PopularSubjectsComponent implements OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();

  // Signals for reactive state management
  subjectsData = signal<Page<PopularSubjectRow>>(GenericTableUtils.EMPTY_PAGE);
  totalElements = signal<number>(0);
  currentPage = signal<number>(0);
  pageSize = signal<number>(10);
  isLoading = signal<boolean>(false);
  sortActive = signal<string>('');
  sortDirection = signal<SortDirection>('');

  private readonly subjectService = inject(SubjectService);
  private readonly router = inject(Router);

  // Generic table configuration
  tableConfig: TableConfig<PopularSubjectRow> = {
    columns: [
      {
        id: 'name',
        header: 'Názov predmetu',
        field: 'name',
        cellRenderer: TextCellRendererComponent,
        width: 'auto',
      },
      {
        id: 'code',
        header: 'Kód',
        field: 'code',
        cellRenderer: TextCellRendererComponent,
        width: '120px',
      },
      {
        id: 'abbreviation',
        header: 'Skratka',
        field: 'abbreviation',
        cellRenderer: TextCellRendererComponent,
        width: '120px',
      },
      {
        id: 'studyProgramName',
        header: 'Študijný program',
        field: 'studyProgramName',
        cellRenderer: TextCellRendererComponent,
        width: '200px',
      },
      {
        id: 'obligation',
        header: 'Povinnosť',
        field: 'obligation',
        cellRenderer: TextCellRendererComponent,
        width: '120px',
        align: 'center',
      },
      {
        id: 'recommendedYear',
        header: 'Ročník',
        field: 'recommendedYear',
        cellRenderer: TextCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'semester',
        header: 'Semester',
        field: 'semester',
        cellRenderer: TextCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'studentCount',
        header: 'Počet študentov',
        field: 'studentCount',
        cellRenderer: TextCellRendererComponent,
        width: '150px',
        align: 'center',
      },
    ],
    serverSide: true,
    enableSorting: true,
    enablePagination: true,
    pageSize: 10,
    pageSizeOptions: [5, 10, 25, 50],
    enableRowClick: true,
    stickyHeader: false,
  };

  constructor() {
    this.loadPopularSubjects(0, 10);
  }

  private loadPopularSubjects(pageNumber: number, pageSize: number): void {
    this.isLoading.set(true);
    const sort = this.buildSortParam();

    this.subjectService
      .getMostPopularElectives(pageNumber, pageSize, sort)
      .pipe(
        tap((page) => {
          this.updateTableData(page);
        }),
        takeUntil(this._destroy$),
        catchError(() => {
          this.isLoading.set(false);
          return of();
        }),
      )
      .subscribe();
  }

  private updateTableData(page: Page<PopularSubjectRow>): void {
    this.subjectsData.set(page);
    this.totalElements.set(page.totalElements);
    this.currentPage.set(page.number);
    this.pageSize.set(page.size);
    this.isLoading.set(false);
  }


  onPageChange(event: PageEvent): void {
    this.loadPopularSubjects(event.pageIndex, event.pageSize);
  }

  onSortChange(sort: { active: string; direction: SortDirection }): void {
    this.sortActive.set(sort.active);
    this.sortDirection.set(sort.direction);

    // Reset to first page when sorting changes
    this.currentPage.set(0);

    // Reload data with new sort
    this.loadPopularSubjects(0, this.pageSize());
  }

  private buildSortParam(): string | undefined {
    const active = this.sortActive();
    const direction = this.sortDirection();

    if (!active || !direction) {
      return undefined;
    }

    // Convert 'asc' to 'ASC' and 'desc' to 'DESC' for backend compatibility
    const sortDirection = direction === 'asc' ? 'ASC' : 'DESC';
    return `${active},${sortDirection}`;
  }

  onRowClick(event: { row: PopularSubjectRow; event: MouseEvent }): void {
    this.navigateToSubjectDetail(event.row.code);
  }

  navigateToSubjectDetail(code: string): void {
    this.router.navigate(['/subjects', code]);
  }

  ngOnDestroy(): void {
    this._destroy$.next();
    this._destroy$.complete();
  }
}

