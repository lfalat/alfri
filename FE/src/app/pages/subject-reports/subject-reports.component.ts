import { Component, DestroyRef, inject, OnInit, signal } from '@angular/core';
import { Router } from '@angular/router';
import { debounceTime } from 'rxjs';
import { Page, SubjectGradesDto } from '../../types';
import { MatCard, MatCardContent, MatCardHeader, MatCardTitle } from '@angular/material/card';
import { SubjectService } from '@services/subject.service';
import {
  GenericTableComponent,
  TableConfig,
  TextCellRendererComponent,
  NumberCellRendererComponent,
  PercentageCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';
import { PageEvent } from '@angular/material/paginator';
import { SortDirection } from '@angular/material/sort';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-subject-reports',
  templateUrl: './subject-reports.component.html',
  standalone: true,
  styleUrls: ['./subject-reports.component.scss'],
  imports: [MatCard, MatCardHeader, MatCardTitle, MatCardContent, GenericTableComponent],
})
export class SubjectReportsComponent implements OnInit {
  private readonly subjectsService = inject(SubjectService);
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);

  // Signals for reactive state management
  subjectsData = signal<Page<SubjectGradesDto & { id: number }>>(GenericTableUtils.EMPTY_PAGE);
  isLoading = signal<boolean>(false);
  currentPage = signal<number>(0);
  pageSize = signal<number>(10);
  sortActive = signal<string>('');
  sortDirection = signal<SortDirection>('asc');
  filterText = signal<string>('');

  // Generic table configuration
  tableConfig: TableConfig<SubjectGradesDto & { id: number }> = {
    columns: [
      {
        id: 'name',
        header: 'Názov',
        field: 'subject.name',
        cellRenderer: TextCellRendererComponent,
        width: 'auto',
      },
      {
        id: 'code',
        header: 'Kód predmetu',
        field: 'subject.code',
        cellRenderer: TextCellRendererComponent,
        width: '150px',
        align: 'center',
      },
      {
        id: 'studentsCount',
        header: 'Počet študentov',
        field: 'studentsCount',
        cellRenderer: NumberCellRendererComponent,
        width: '150px',
        align: 'center',
      },
      {
        id: 'averageScore',
        header: 'Priemerná známka',
        field: 'gradeAverage',
        cellRenderer: NumberCellRendererComponent,
        width: '150px',
        align: 'center',
      },
      {
        id: 'gradeA',
        header: 'A',
        field: 'gradeA',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'gradeB',
        header: 'B',
        field: 'gradeB',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'gradeC',
        header: 'C',
        field: 'gradeC',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'gradeD',
        header: 'D',
        field: 'gradeD',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'gradeE',
        header: 'E',
        field: 'gradeE',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'gradeFx',
        header: 'FX',
        field: 'gradeFx',
        sortable: true,
        cellRenderer: PercentageCellRendererComponent,
        width: '100px',
        align: 'center',
      },
    ],
    serverSide: true,
    enableSorting: true,
    enablePagination: true,
    pageSize: 10,
    pageSizeOptions: [5, 10, 20, 50],
    enableRowClick: true,
    stickyHeader: true,
    header: {
      show: true,
      enableSearch: true,
      searchPlaceholder: 'Vyhľadať predmet...',
    },
  };

  ngOnInit(): void {
    this.fetchFilteredSubjects();
  }

  private buildSortParam(): string | undefined {
    if (!this.sortActive() || this.sortDirection() === '') {
      return undefined;
    }
    return `${this.sortActive()},${this.sortDirection()}`;
  }

  fetchFilteredSubjects(pageNumber?: number, pageSize?: number, sort?: string, filter?: string): void {
    this.isLoading.set(true);

    const page = pageNumber ?? this.currentPage();
    const size = pageSize ?? this.pageSize();
    const sortParam = sort ?? this.buildSortParam();
    const searchParam = filter ?? this.filterText();

    // Fetch subjects with server-side pagination
    this.subjectsService
      .getSubjectsWithGrades(page, size, sortParam, searchParam || undefined)
      .pipe(takeUntilDestroyed(this.destroyRef), debounceTime(300))
      .subscribe({
        next: (data) => {
          // Add id property to each item
          const pageData: Page<SubjectGradesDto & { id: number }> = {
            ...data,
            content: data.content.map((item) => ({
              ...item,
              id: item.subject.id, // Use subject id
            })),
          };

          this.subjectsData.set(pageData);
          this.currentPage.set(data.number);
          this.pageSize.set(data.size);
          this.isLoading.set(false);
        },
        error: (error) => {
          console.error('Error fetching subjects:', error);
          this.isLoading.set(false);
        },
      });
  }

  onPageChange(event: PageEvent): void {
    // Set loading state immediately to prevent flicker
    this.isLoading.set(true);
    this.fetchFilteredSubjects(event.pageIndex, event.pageSize);
  }

  onSortChange(sort: { active: string; direction: SortDirection }): void {
    // Set loading state immediately to prevent flicker
    this.isLoading.set(true);

    this.sortActive.set(sort.active);
    this.sortDirection.set(sort.direction);

    // Reset to first page when sorting changes
    this.currentPage.set(0);

    // Reload data with new sort
    this.fetchFilteredSubjects(0, this.pageSize());
  }

  onFilterChange(filter: string): void {
    this.filterText.set(filter);
    this.currentPage.set(0);
    this.fetchFilteredSubjects(0, this.pageSize(), undefined, filter);
  }

  onRowClick(event: { row: SubjectGradesDto & { id: number }; event: MouseEvent }): void {
    this.router.navigate(['/subjects', event.row.subject.code]);
  }
}
