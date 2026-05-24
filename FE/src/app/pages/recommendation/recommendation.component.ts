import { Component, inject, OnDestroy, OnInit, signal } from '@angular/core';
import { Router } from '@angular/router';
import { HttpErrorResponse } from '@angular/common/http';
import { NotificationService } from '@services/notification.service';
import { StudentService } from '@services/student.service';
import { Observable, of, Subject } from 'rxjs';
import { catchError, switchMap, takeUntil, tap } from 'rxjs/operators';
import { Page, SubjectDto } from '../../types';
import { MatCard, MatCardHeader, MatCardSubtitle, MatCardTitle } from '@angular/material/card';
import { SubjectService } from '@services/subject.service';
import { PageEvent } from '@angular/material/paginator';
import {
  GenericTableComponent,
  TableConfig,
  TextCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';

@Component({
  selector: 'app-recommendation',
  templateUrl: './recommendation.component.html',
  standalone: true,
  imports: [GenericTableComponent, MatCard, MatCardHeader, MatCardSubtitle, MatCardTitle],
  styleUrls: ['./recommendation.component.scss'],
})
export class RecommendationComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();

  // Signals for reactive state management
  subjectsData = signal<Page<SubjectDto>>(GenericTableUtils.EMPTY_PAGE);
  totalElements = signal<number>(0);
  currentPage = signal<number>(0);
  pageSize = signal<number>(10);
  isLoading = signal<boolean>(false);

  // Generic table configuration
  tableConfig: TableConfig<SubjectDto> = {
    columns: [
      {
        id: 'name',
        header: 'Názov predmetu',
        field: 'name',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: 'auto',
      },
      {
        id: 'code',
        header: 'Kód',
        field: 'code',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: '120px',
      },
      {
        id: 'abbreviation',
        header: 'Skratka',
        field: 'abbreviation',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: '120px',
      },
      {
        id: 'obligation',
        header: 'Povinnosť',
        field: 'obligation',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: '120px',
        align: 'center',
      },
      {
        id: 'recommendedYear',
        header: 'Ročník',
        field: 'recommendedYear',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: '100px',
        align: 'center',
      },
      {
        id: 'semester',
        header: 'Semester',
        field: 'semester',
        sortable: true,
        cellRenderer: TextCellRendererComponent,
        width: '100px',
        align: 'center',
      },
    ],
    serverSide: false,
    enableSorting: true,
    enablePagination: true,
    pageSize: 10,
    pageSizeOptions: [5, 10, 25, 50],
    enableRowClick: true,
    stickyHeader: false,
  };

  private readonly subjectService = inject(SubjectService);
  private readonly studentService = inject(StudentService);
  private readonly errorService = inject(NotificationService);
  private readonly router = inject(Router);

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this.studentService
      .getStudyProgramOfCurrentUser()
      .pipe(
        switchMap(() => {
          return this.getSubjects();
        }),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error);
          return of([]);
        }),
      )
      .subscribe((page) => {
        if (Array.isArray(page)) {
          return;
        }

        this.updateTableData(page);
      });
  }

  private updateTableData(page: Page<SubjectDto>): void {
    this.subjectsData.set(page);
    this.totalElements.set(page.totalElements);
    this.currentPage.set(page.number);
    this.pageSize.set(page.size);
  }

  private getSubjects(): Observable<Page<SubjectDto> | never[]> {
    this.isLoading.set(true);
    return this.subjectService.getSubjectFocusPrediction(this.currentPage(), this.pageSize()).pipe(
      tap((page: Page<SubjectDto>) => {
        this.isLoading.set(false);
        return page;
      }),
      takeUntil(this._destroy$),
      catchError((error: HttpErrorResponse) => {
        this.isLoading.set(false);
        this.errorService.showError(error.error.detail);
        return of([]);
      }),
    );
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  public onRowClick(event: { row: SubjectDto; event: MouseEvent }): void {
    this.navigateToSubjectDetail(event.row.code);
  }

  public navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }

  public onPageChange(event: PageEvent): void {
    this.currentPage.set(event.pageIndex);
    this.pageSize.set(event.pageSize);

    this.getSubjects().subscribe((page) => {
      if (Array.isArray(page)) {
        return;
      }

      this.updateTableData(page);
    });
  }
}
