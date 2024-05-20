import { Component, OnDestroy, OnInit } from '@angular/core';
import { catchError, map, Observable, of, shareReplay, Subject, switchMap, takeUntil, tap } from 'rxjs';
import { Page, StudyProgramDto, SubjectDto } from '../types';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { SubjectService } from '../services/subject.service';
import { ErrorService } from '../services/error.service';
import { HttpErrorResponse } from '@angular/common/http';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { AsyncPipe } from '@angular/common';
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
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatOption } from '@angular/material/autocomplete';
import { MatProgressBar } from '@angular/material/progress-bar';
import { MatSelect } from '@angular/material/select';
import { MatInput } from '@angular/material/input';
import { MatButton } from '@angular/material/button';
import { StudentService } from '../services/student.service';

@Component({
  selector: 'app-recommendation',
  standalone: true,
  imports: [
    AsyncPipe,
    MatCell,
    MatCellDef,
    MatColumnDef,
    MatFormField,
    MatHeaderCell,
    MatHeaderRow,
    MatHeaderRowDef,
    MatLabel,
    MatOption,
    MatPaginator,
    MatProgressBar,
    MatRow,
    MatRowDef,
    MatSelect,
    MatTable,
    MatHeaderCellDef,
    ReactiveFormsModule,
    MatInput,
    MatButton
  ],
  templateUrl: './recommendation.component.html',
  styleUrl: './recommendation.component.scss'
})
export class RecommendationComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private _dataSource$!: Observable<Page<SubjectDto>>;
  private _userStudyProgramId!: number;
  public filterForm: FormGroup;
  private isFilterActive = false;

  public readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'abbreviation',
    'obligation',
  ];

  public readonly pageData: Page<SubjectDto> = {
    content: [],
    totalElements: 0,
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

  public isLoading = false;

  get dataSource$(): Observable<SubjectDto[]> {
    if (!this._dataSource$) {
      return of();
    }

    return this._dataSource$.pipe(map((page) => page.content));
  }


  constructor(
    private subjectService: SubjectService,
    private studentService: StudentService,
    private errorService: ErrorService,
    private formBuilder: FormBuilder
  ) {
    this.filterForm = this.formBuilder.group(
      {
        mathFocus: ['', [Validators.required]]
      }
    );
  }

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this.studentService.getStudyProgramOfCurrentUser().pipe(
      switchMap((studyProgram: StudyProgramDto) => {
        this._userStudyProgramId = studyProgram.id;
        return this.getSubjects(0, 10, this._userStudyProgramId);
      }),
      catchError((error: HttpErrorResponse) => {
        this.errorService.showError(error.error.detail);
        return of({
          content: [],
          totalElements: 0,
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
          empty: true,
        });
      })
    ).subscribe(page => {
      this._dataSource$ = of(page);
    });
  }

  private getSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number
  ): Observable<Page<SubjectDto>> {
    if (this.isFilterActive) {
      return this.subjectService
        .filterSubject(this.filterForm.value.mathFocus, studyProgramId, pageNumber, pageSize)
        .pipe(
          tap((page: Page<SubjectDto>) => {
            this.pageData.size = page.size;
            this.pageData.totalElements = page.totalElements;
            this.pageData.number = page.number;
            this.isLoading = false;
          }),
          takeUntil(this._destroy$),
          catchError((error: HttpErrorResponse) => {
            this.errorService.showError(error.error.detail);
            return of();
          }),
          shareReplay(1)
        );
    }

    return this.subjectService
      .getSubjectsByStudyProgramId(studyProgramId, pageNumber, pageSize)
      .pipe(
        tap((page: Page<SubjectDto>) => {
          this.pageData.size = page.size;
          this.pageData.totalElements = page.totalElements;
          this.pageData.number = page.number;
          this.isLoading = false;
        }),
        takeUntil(this._destroy$),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error.detail);
          return of();
        }),
        shareReplay(1)
      );
  }

  public onPageChange($event: PageEvent) {
    this.isLoading = true;

    this._dataSource$ = this.getSubjects(
      $event.pageIndex,
      $event.pageSize,
      this._userStudyProgramId
    );
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  // // TODO make more dynamic
  filterByMathThreshold() {
    this.isFilterActive = true;
    this._dataSource$ = this.getSubjects(0, 10, this._userStudyProgramId);
  }
}
