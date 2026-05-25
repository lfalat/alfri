import { Component, inject, OnDestroy, OnInit, ViewChild, signal, computed } from '@angular/core';
import {
  catchError,
  debounceTime,
  distinctUntilChanged,
  finalize,
  Observable,
  of,
  shareReplay,
  Subject,
  switchMap,
  takeUntil,
  tap,
} from 'rxjs';
import { Router } from '@angular/router';
import { PageEvent } from '@angular/material/paginator';
import { SortDirection } from '@angular/material/sort';
import { HttpErrorResponse } from '@angular/common/http';
import { StudentService } from '@services//student.service';
import { NotificationService } from '@services//notification.service';
import { MatButton } from '@angular/material/button';
import { MatIcon } from '@angular/material/icon';
import { MatProgressBar } from '@angular/material/progress-bar';
import { Page, StudyProgramDto, SubjectDto, SubjectExtendedDto } from '../../types';
import { MatCard, MatCardContent, MatCardHeader, MatCardTitle } from '@angular/material/card';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { SubjectService } from '@services/subject.service';
import { MatStepper, MatStepperModule } from '@angular/material/stepper';
import { MatFormField, MatLabel, MatSuffix } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { FormsModule } from '@angular/forms';
import {
  GenericTableComponent,
  TableConfig,
  TextCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';

@Component({
  selector: 'app-subjects-clustering',
  standalone: true,
  imports: [
    GenericTableComponent,
    MatButton,
    MatIcon,
    MatProgressBar,
    MatCard,
    MatCardHeader,
    MatCardContent,
    MatCardTitle,
    NgxSkeletonLoaderModule,
    MatStepperModule,
    MatFormField,
    MatLabel,
    MatInput,
    FormsModule,
    MatSuffix,
  ],
  templateUrl: './subjects-clustering.component.html',
  styleUrls: ['./subjects-clustering.component.scss'],
})
export class SubjectsClusteringComponent implements OnInit, OnDestroy {
  @ViewChild('stepper') stepper!: MatStepper;

  private readonly _destroy$: Subject<void> = new Subject();
  private readonly _searchTerm$: Subject<string> = new Subject();
  private _userStudyProgramId!: number;

  // Signals for reactive state management
  private readonly _selectedSubjects = signal<SubjectExtendedDto[]>([]);
  private readonly _recommendedSubjects = signal<SubjectDto[]>([]);
  readonly allSubjectsData = signal<Page<SubjectExtendedDto>>(GenericTableUtils.EMPTY_PAGE);
  readonly isLoadingAllSubjects = signal<boolean>(false);
  readonly isLoadingRecommendetSubjects = signal<boolean>(false);
  searchTerm = signal<string>('');
  sortActive = signal<string>('');
  sortDirection = signal<SortDirection>('');

  // Generic table configurations
  allSubjectsTableConfig: TableConfig<SubjectExtendedDto> = {
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
    ],
    serverSide: true,
    enableSorting: true,
    enablePagination: true,
    pageSize: 10,
    pageSizeOptions: [5, 10, 25, 50],
    enableRowClick: false,
    enableSelection: true,
    selectionMode: 'multiple',
    highlightSelection: true,
    maxSelection: 3,
    stickyHeader: false,
  };

  selectedSubjectsTableConfig: TableConfig<SubjectExtendedDto> = {
    columns: [
      {
        id: 'name',
        header: 'Názov predmetu',
        field: 'name',
        sortable: false,
        cellRenderer: TextCellRendererComponent,
        width: 'auto',
      },
      {
        id: 'code',
        header: 'Kód',
        field: 'code',
        sortable: false,
        cellRenderer: TextCellRendererComponent,
        width: '100px',
      },
    ],
    enableSorting: false,
    enablePagination: false,
    enableRowClick: true,
    stickyHeader: false,
  };

  recommendedSubjectsTableConfig: TableConfig<SubjectDto> = {
    columns: [
      {
        id: 'name',
        header: 'Názov predmetu',
        field: 'name',
        sortable: false,
        cellRenderer: TextCellRendererComponent,
        width: 'auto',
      },
      {
        id: 'code',
        header: 'Kód',
        field: 'code',
        sortable: false,
        cellRenderer: TextCellRendererComponent,
        width: '100px',
      },
    ],
    enableSorting: false,
    enablePagination: false,
    enableRowClick: true,
    stickyHeader: false,
  };

  // Computed signals for reactive page data
  readonly selectedSubjects = computed(() => this._selectedSubjects());

  readonly selectedSubjectsPageData = computed<Page<SubjectExtendedDto>>(() => {
    const subjects = this._selectedSubjects();
    return {
      content: subjects,
      totalElements: subjects.length,
      size: subjects.length,
      number: 0,
      pageable: {
        sort: { sorted: false, unsorted: true, empty: true },
        offset: 0,
        pageNumber: 0,
        pageSize: subjects.length,
        paged: false,
        unpaged: true,
      },
      last: true,
      totalPages: 1,
      sort: { sorted: false, unsorted: true, empty: true },
      first: true,
      numberOfElements: subjects.length,
      empty: subjects.length === 0,
    };
  });

  readonly recommendedSubjectsPageDataComputed = computed<Page<SubjectDto>>(() => {
    const subjects = this._recommendedSubjects();
    return {
      content: subjects,
      totalElements: subjects.length,
      size: subjects.length,
      number: 0,
      pageable: {
        sort: { sorted: false, unsorted: true, empty: true },
        offset: 0,
        pageNumber: 0,
        pageSize: subjects.length,
        paged: false,
        unpaged: true,
      },
      last: true,
      totalPages: 1,
      sort: { sorted: false, unsorted: true, empty: true },
      first: true,
      numberOfElements: subjects.length,
      empty: subjects.length === 0,
    };
  });

  private readonly subjectService = inject(SubjectService);
  private readonly studentService = inject(StudentService);
  private readonly errorService = inject(NotificationService);
  private readonly router = inject(Router);

  ngOnInit() {
    this.init();
    this.setupSearchSubscription();
  }

  private init(): void {
    this.getStudentsStudyProgramAndItsSubjects();
    this._recommendedSubjects.set([]);
  }

  private setupSearchSubscription(): void {
    this._searchTerm$
      .pipe(
        debounceTime(300),
        distinctUntilChanged(),
        tap(() => this.isLoadingAllSubjects.set(true)),
        switchMap((searchTerm: string) => {
          const searchParam = searchTerm.trim()
            ? `studyProgram.id:${this._userStudyProgramId},subject.name~${searchTerm}`
            : `studyProgram.id:${this._userStudyProgramId}`;
          return this.getAllSubjectsWithSearch(0, 10, searchParam).pipe(
            catchError((error: HttpErrorResponse) => {
              this.errorService.showError(error.error);
              return of(GenericTableUtils.EMPTY_PAGE as Page<SubjectExtendedDto>);
            }),
            finalize(() => this.isLoadingAllSubjects.set(false)),
          );
        }),
        takeUntil(this._destroy$),
      )
      .subscribe((page) => {
        this.updateAllSubjectsTableData(page);
      });
  }

  private updateAllSubjectsTableData(page: Page<SubjectExtendedDto>): void {
    this.allSubjectsData.set(page);
  }

  onSearchChange(searchTerm: string): void {
    this.searchTerm.set(searchTerm);
    this._searchTerm$.next(searchTerm);
  }

  private getStudentsStudyProgramAndItsSubjects() {
    this.isLoadingAllSubjects.set(true);
    this.studentService
      .getStudyProgramOfCurrentUser()
      .pipe(
        switchMap((studyProgram: StudyProgramDto) => {
          this._userStudyProgramId = studyProgram.id;
          return this.getAllSubjects(0, 10, this._userStudyProgramId);
        }),
        finalize(() => {
          this.isLoadingAllSubjects.set(false);
        }),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error);
          return of(GenericTableUtils.EMPTY_PAGE as Page<SubjectExtendedDto>);
        }),
      )
      .subscribe((page) => {
        this.updateAllSubjectsTableData(page);
      });
  }

  private getAllSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number,
  ): Observable<Page<SubjectExtendedDto>> {
    const sort = this.buildSortParam();
    return this.subjectService
      .getSubjectsWithFocusByStudyProgramId(studyProgramId, pageNumber, pageSize, sort)
      .pipe(
        takeUntil(this._destroy$),
        catchError(() => {
          return of();
        }),
        shareReplay(1),
      );
  }

  private getAllSubjectsWithSearch(
    pageNumber: number,
    pageSize: number,
    searchParam: string,
  ): Observable<Page<SubjectExtendedDto>> {
    const sort = this.buildSortParam();
    return this.subjectService
      .getSubjectsWithFocusByStudyProgramIdAndSearch(pageNumber, pageSize, searchParam, sort)
      .pipe(
        takeUntil(this._destroy$),
        catchError(() => {
          return of();
        }),
        shareReplay(1),
      );
  }

  onPageChangeAllSubjects(event: PageEvent) {
    this.isLoadingAllSubjects.set(true);

    const searchParam = this.searchTerm().trim()
      ? `studyProgramId:${this._userStudyProgramId},subject.name~${this.searchTerm()}`
      : `studyProgramId:${this._userStudyProgramId}`;

    const subjects$ = this.searchTerm().trim()
      ? this.getAllSubjectsWithSearch(event.pageIndex, event.pageSize, searchParam)
      : this.getAllSubjects(event.pageIndex, event.pageSize, this._userStudyProgramId);

    subjects$
      .pipe(
        finalize(() => this.isLoadingAllSubjects.set(false)),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error);
          return of(GenericTableUtils.EMPTY_PAGE as Page<SubjectExtendedDto>);
        }),
      )
      .subscribe((page) => {
        this.updateAllSubjectsTableData(page);
      });
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }

  onRowClick(subject: SubjectDto | SubjectExtendedDto) {
    this.navigateToSubjectDetail(subject.code);
  }

  onSelectionChange(selectedSubjects: SubjectExtendedDto[]) {
    this._selectedSubjects.set(selectedSubjects);
  }

  onSortChange(sort: { active: string; direction: SortDirection }): void {
    this.sortActive.set(sort.active);
    this.sortDirection.set(sort.direction);

    // Reload data with new sort
    this.isLoadingAllSubjects.set(true);

    const searchParam = this.searchTerm().trim()
      ? `studyProgramId:${this._userStudyProgramId},subject.name~${this.searchTerm()}`
      : `studyProgramId:${this._userStudyProgramId}`;

    const subjects$ = this.searchTerm().trim()
      ? this.getAllSubjectsWithSearch(
          this.allSubjectsData().number,
          this.allSubjectsData().size,
          searchParam,
        )
      : this.getAllSubjects(
          this.allSubjectsData().number,
          this.allSubjectsData().size,
          this._userStudyProgramId,
        );

    subjects$
      .pipe(
        finalize(() => this.isLoadingAllSubjects.set(false)),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error);
          return of(GenericTableUtils.EMPTY_PAGE as Page<SubjectExtendedDto>);
        }),
      )
      .subscribe((page) => {
        this.updateAllSubjectsTableData(page);
      });
  }

  private buildSortParam(): string | undefined {
    const active = this.sortActive();
    const direction = this.sortDirection();

    if (!active || !direction) {
      return undefined;
    }

    // Convert 'asc' to 'ASC' and 'desc' to 'DESC' for backend compatibility
    const sortDirection = direction === 'asc' ? 'ASC' : 'DESC';
    return `subject.${active},${sortDirection}`;
  }

  getSimilarSubjects() {
    // Move to next step immediately to show loading state
    if (this.stepper) {
      this.stepper.next();
    }

    this.isLoadingRecommendetSubjects.set(true);

    this.subjectService
      .getSimilarSubjects(this._selectedSubjects())
      .pipe(
        tap((subjects: SubjectDto[]) => {
          // Update signal with recommended subjects
          this._recommendedSubjects.set(subjects);
        }),
        finalize(() => {
          this.isLoadingRecommendetSubjects.set(false);
        }),
        takeUntil(this._destroy$),
      )
      .subscribe();
  }
}
