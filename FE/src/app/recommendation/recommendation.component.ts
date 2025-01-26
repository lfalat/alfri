import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { HttpErrorResponse } from '@angular/common/http';
import { SubjectService } from '../services/subject.service';
import { NotificationService } from '../services/notification.service';
import { StudentService } from '../services/student.service';
import { PageEvent } from '@angular/material/paginator';
import { map, Observable, of, Subject } from 'rxjs';
import { catchError, switchMap, takeUntil, tap } from 'rxjs/operators';
import { Page, StudyProgramDto, SubjectDto } from '../types';
import { SubjectsTableComponent } from '../components/subjects-table/subjects-table.component';
import { MatButton } from '@angular/material/button';
import { AsyncPipe } from '@angular/common';

@Component({
  selector: 'app-recommendation',
  templateUrl: './recommendation.component.html',
  standalone: true,
  imports: [
    SubjectsTableComponent,
    MatButton,
    AsyncPipe
  ],
  styleUrls: ['./recommendation.component.scss']
})
export class RecommendationComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private _dataSource$!: Observable<SubjectDto[]>;
  private _userStudyProgramId!: number;
  public readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'abbreviation',
    'obligation',
    'recommendedYear',
    'semester',
  ];

  get dataSource$(): Observable<SubjectDto[]> {
    if (!this._dataSource$) {
      return of([]);
    }

    return this._dataSource$.pipe(map((page) => page));
  }

  public pageData: Page<SubjectDto> = {
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
  };


  public readonly pageSizeOptions: number[] = [5, 10, 20]; // Static number of elements per page
  public pageSize = 10; // Default page size

  public isLoading = false;

  constructor(
    private subjectService: SubjectService,
    private studentService: StudentService,
    private errorService: NotificationService,
    private router: Router
  ) {
  }

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this.studentService.getStudyProgramOfCurrentUser().pipe(
      switchMap((studyProgram: StudyProgramDto) => {
        this._userStudyProgramId = studyProgram.id;
        return this.getSubjects(0, this.pageSize, this._userStudyProgramId);
      }),
      catchError((error: HttpErrorResponse) => {
        this.errorService.showError(error.error);
        return of([]);
      })
    ).subscribe(subjects => {
      this._dataSource$ = of(subjects);
    });
  }

  private getSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number
  ): Observable<SubjectDto[]> {
    this.isLoading = true;
    return this.subjectService
      .getSubjectFocusPrediction()
      .pipe(
        tap((subjects: SubjectDto[]) => {
          this.isLoading = false;
          return subjects;
        }),
        takeUntil(this._destroy$),
        catchError((error: HttpErrorResponse) => {
          this.isLoading = false;
          this.errorService.showError(error.error.detail);
          return of([]);
        })
      );
  }

  public onPageChange($event: PageEvent) {
    this.isLoading = true;
    this.pageSize = $event.pageSize;

    this.getSubjects(
      $event.pageIndex,
      $event.pageSize,
      this._userStudyProgramId
    ).subscribe(subjects => {
      this._dataSource$ = of(subjects);
    });
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  public navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }
}
