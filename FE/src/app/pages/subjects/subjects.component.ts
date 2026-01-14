import { Component, inject, OnDestroy, OnInit, signal } from '@angular/core';
import {
  catchError,
  debounceTime,
  distinctUntilChanged,
  Observable,
  of,
  Subject,
  switchMap,
  takeUntil,
  tap,
} from 'rxjs';
import { StudyProgramService } from '@services/study-program.service';
import { CommonModule } from '@angular/common';
import { PageEvent } from '@angular/material/paginator';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatOptionModule } from '@angular/material/core';
import {
  FormBuilder,
  FormGroup,
  FormsModule,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Page, StudyProgramDto, SubjectDto } from '../../types';
import { MatCard, MatCardContent } from '@angular/material/card';
import { SubjectService } from '@services/subject.service';
import { MatInput } from '@angular/material/input';
import { MatIcon } from '@angular/material/icon';
import {
  GenericTableComponent,
  TableConfig,
  TextCellRendererComponent,
} from '@components/generic-table';
import { GenericTableUtils } from '@components/generic-table/generic-table.utils';
import { SortDirection } from '@angular/material/sort';
import { FormDataService } from '@services/form-data.service';

@Component({
  selector: 'app-subjects',
  standalone: true,
  imports: [
    CommonModule,
    MatSelectModule,
    MatFormFieldModule,
    MatOptionModule,
    FormsModule,
    ReactiveFormsModule,
    GenericTableComponent,
    MatCard,
    MatCardContent,
    MatInput,
    MatIcon,
  ],
  templateUrl: './subjects.component.html',
  styleUrls: ['./subjects.component.scss'],
})
export class SubjectsComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private readonly _searchTerm$: Subject<string> = new Subject();

  // Signals for reactive state management
  subjectsData = signal<Page<SubjectDto>>(GenericTableUtils.EMPTY_PAGE);
  totalElements = signal<number>(0);
  currentPage = signal<number>(0);
  pageSize = signal<number>(10);
  isLoading = signal<boolean>(false);
  searchTerm = signal<string>('');
  sortActive = signal<string>('');
  sortDirection = signal<SortDirection>('');

  private _studyPrograms$!: Observable<StudyProgramDto[]>;
  private _selectedStudyProgramId!: number;
  filterForm: FormGroup;

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
    serverSide: true,
    enableSorting: true,
    enablePagination: true,
    pageSize: 10,
    pageSizeOptions: [5, 10, 25, 50],
    enableRowClick: true,
    stickyHeader: false,
  };

  private readonly subjectService = inject(SubjectService);
  private readonly studyProgramService = inject(StudyProgramService);
  private readonly formBuilder = inject(FormBuilder);
  private readonly router = inject(Router);
  private readonly activatedRoute = inject(ActivatedRoute);
  private readonly formDataService = inject(FormDataService);

  constructor() {
    this.filterForm = this.formBuilder.group({
      subjectForm: ['', [Validators.required]],
    });
  }

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this._studyPrograms$ = this.studyProgramService
      .getAll()
      .pipe(takeUntil(this._destroy$));

    const formData = this.formDataService.getFormData()
    const studyProgramId = formData?.sections[0].questions.find(question => question.id === 109)?.answers[0].texts[0].textOfAnswer;
    if (!studyProgramId) {
      throw new Error('Study program ID not found in form data');
    }
    this._selectedStudyProgramId = Number.parseInt(studyProgramId);
    this.filterForm.patchValue({ subjectForm: this._selectedStudyProgramId });

    this.setupSearchSubscription();
    this.getSubjects(0, 10, this._selectedStudyProgramId);
  }

  private setupSearchSubscription(): void {
    this._searchTerm$
      .pipe(
        debounceTime(300),
        distinctUntilChanged(),
        tap(() => this.isLoading.set(true)),
        switchMap((searchTerm: string) => {
          const searchParam = `studyProgram.id:${this._selectedStudyProgramId},subject.name~${searchTerm}`;
          return this.getSubjectsWithSearch(0, this.pageSize(), searchParam);
        }),
        catchError(() => {
          this.isLoading.set(false);
          return of({
            content: [],
            totalElements: 0,
            size: 10,
            number: 0,
          });
        }),
        takeUntil(this._destroy$),
      )
      .subscribe((page) => {
        this.updateTableData(page as Page<SubjectDto>);
      });
  }

  onSearchChange(searchTerm: string): void {
    this._searchTerm$.next(searchTerm);
  }

  private convertToTableRow(subject: SubjectDto): SubjectDto {
    return {
      ...subject,
      id: subject.id,
    };
  }

  private updateTableData(page: Page<SubjectDto>): void {
    this.subjectsData.set({
      ...page,
      content: page.content.map((s) => this.convertToTableRow(s)),
    });
    this.totalElements.set(page.totalElements);
    this.currentPage.set(page.number);
    this.pageSize.set(page.size);
    this.isLoading.set(false);
  }

  private getSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number,
  ): void {
    this.isLoading.set(true);
    const sort = this.buildSortParam();
    this.subjectService
      .getSubjectsWithFocusByStudyProgramId(
        studyProgramId,
        pageNumber,
        pageSize,
        sort,
      )
      .pipe(
        tap((page: Page<SubjectDto>) => {
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

  private getSubjectsWithSearch(
    pageNumber: number,
    pageSize: number,
    searchParam: string,
  ): Observable<Page<SubjectDto>> {
    const sort = this.buildSortParam();
    return this.subjectService
      .getSubjectsWithFocusByStudyProgramIdAndSearch(
        pageNumber,
        pageSize,
        searchParam,
        sort,
      )
      .pipe(
        takeUntil(this._destroy$),
        catchError(() => {
          return of();
        }),
      );
  }

  onPageChange(event: PageEvent) {
    this.isLoading.set(true);

    if (this.searchTerm().trim()) {
      const searchParam = `studyProgramId:${this._selectedStudyProgramId},subject.name~${this.searchTerm()}`;
      this.getSubjectsWithSearch(event.pageIndex, event.pageSize, searchParam)
        .pipe(
          tap((page: Page<SubjectDto>) => {
            this.updateTableData(page);
          }),
          catchError(() => {
            this.isLoading.set(false);
            return of();
          }),
        )
        .subscribe();
    } else {
      this.getSubjects(
        event.pageIndex,
        event.pageSize,
        this._selectedStudyProgramId,
      );
    }
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  onRowClick(event: { row: SubjectDto; event: MouseEvent }): void {
    this.navigateToSubjectDetail(event.row.code);
  }

  onSortChange(sort: { active: string; direction: SortDirection }): void {
    this.sortActive.set(sort.active);
    this.sortDirection.set(sort.direction);

    // Reset to first page when sorting changes
    this.currentPage.set(0);

    // Reload data with new sort
    if (this.searchTerm().trim()) {
      const searchParam = `studyProgramId:${this._selectedStudyProgramId},subject.name~${this.searchTerm()}`;
      this.getSubjectsWithSearch(0, this.pageSize(), searchParam)
        .pipe(
          tap((page: Page<SubjectDto>) => {
            this.updateTableData(page);
          }),
          catchError(() => {
            this.isLoading.set(false);
            return of();
          }),
        )
        .subscribe();
    } else {
      this.getSubjects(0, this.pageSize(), this._selectedStudyProgramId);
    }
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

  navigateToSubjectDetail(code: string) {
    this.router.navigate([code], { relativeTo: this.activatedRoute });
  }
}
