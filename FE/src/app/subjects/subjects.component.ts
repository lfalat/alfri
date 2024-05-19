import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import {
  EMPTY,
  Observable,
  Subject,
  catchError,
  map,
  shareReplay,
  takeUntil,
  tap,
} from 'rxjs';
import { Page, StudyProgramDto, SubjectDto } from '../types';
import { SubjectService } from '../services/subject.service';
import { StudyProgramService } from '../services/study-program.service';
import { CommonModule } from '@angular/common';
import { HttpErrorResponse } from '@angular/common/http';
import { ErrorService } from '../services/error.service';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSelectModule } from '@angular/material/select';

@Component({
  selector: 'app-subjects',
  standalone: true,
  imports: [
    MatTableModule,
    CommonModule,
    MatPaginatorModule,
    MatProgressBarModule,
    MatSelectModule,
  ],
  templateUrl: './subjects.component.html',
  styleUrl: './subjects.component.scss',
})
export class SubjectsComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private _loadingSubject = new Subject<boolean>();
  private _dataSource$!: Observable<Page<SubjectDto>>;
  private _studyPrograms$!: Observable<StudyProgramDto[]>;
  private _selectedStudyProgramId = 1;
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
    return this._dataSource$.pipe(map((page) => page.content));
  }

  get studyPrograms$(): Observable<StudyProgramDto[]> {
    return this._studyPrograms$;
  }

  get selectedStudyProgramId(): number {
    return this._selectedStudyProgramId;
  }

  set selectedStudyProgramId(selected: number) {
    this._selectedStudyProgramId = selected;
  }

  constructor(
    private subjectService: SubjectService,
    private studyProgramService: StudyProgramService,
    private errorService: ErrorService
  ) {}

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this._dataSource$ = this.getSubjects(0, 10, this._selectedStudyProgramId);

    this._studyPrograms$ = this.studyProgramService
      .getAll()
      .pipe(takeUntil(this._destroy$));
  }

  private getSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number
  ): Observable<Page<SubjectDto>> {
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
          return EMPTY;
        }),
        shareReplay(1)
      );
  }

  public studyProgramChanged() {
    this.isLoading = true;
    this._dataSource$ = this.getSubjects(
      0,
      this.pageData.size,
      this._selectedStudyProgramId
    );
  }

  public onPageChange($event: PageEvent) {
    this.isLoading = true;
    this._dataSource$ = this.getSubjects(
      $event.pageIndex,
      $event.pageSize,
      this._selectedStudyProgramId
    );
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }
}
