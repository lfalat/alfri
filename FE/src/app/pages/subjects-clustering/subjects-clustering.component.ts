import { Component, OnDestroy, OnInit } from '@angular/core';
import { SubjectsTableComponent } from '@components//subjects-table/subjects-table.component';
import {
  catchError,
  finalize,
  map,
  Observable,
  of,
  shareReplay,
  Subject,
  switchMap,
  takeUntil,
  tap,
} from 'rxjs';
import { SubjectService } from '@services//subject.service';
import { Router } from '@angular/router';
import { PageEvent } from '@angular/material/paginator';
import { HttpErrorResponse } from '@angular/common/http';
import { StudentService } from '@services//student.service';
import { NotificationService } from '@services//notification.service';
import { MatButton } from '@angular/material/button';
import { MatDivider } from '@angular/material/divider';
import { MatIcon } from '@angular/material/icon';
import { MatProgressBar } from '@angular/material/progress-bar';
import { AsyncPipe } from '@angular/common';
import {
  Page,
  StudyProgramDto,
  SubjectDto,
  SubjectExtendedDto,
} from '../../types';
import { MatCard, MatCardContent, MatCardHeader, MatCardSubtitle, MatCardTitle } from '@angular/material/card';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@Component({
  selector: 'app-subjects-clustering',
  standalone: true,
  imports: [
    SubjectsTableComponent,
    MatButton,
    MatDivider,
    MatIcon,
    MatProgressBar,
    AsyncPipe,
    MatCard,
    MatCardHeader,
    MatCardContent,
    MatCardTitle,
    MatCardSubtitle,
    NgxSkeletonLoaderModule,
  ],
  templateUrl: './subjects-clustering.component.html',
  styleUrl: './subjects-clustering.component.scss',
})
export class SubjectsClusteringComponent implements OnInit, OnDestroy {
  private readonly _destroy$: Subject<void> = new Subject();
  private _allSubjectsDataSource$!: Observable<Page<SubjectExtendedDto>>;
  private _recommendedSubjectsDataSource$!: Observable<SubjectDto[]>;
  private _userStudyProgramId!: number;
  private _selectedSubjects: SubjectExtendedDto[] = [];

  public readonly allSubjectsPageData: Page<SubjectExtendedDto> = {
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

  public isLoadingAllSubjects = false;
  public isLoadingRecommendetSubjects = false;

  get allSubjectsDataSource$(): Observable<SubjectExtendedDto[]> {
    if (!this._allSubjectsDataSource$) {
      return of([]);
    }

    return this._allSubjectsDataSource$.pipe(map((page) => page.content));
  }

  get selectedSubjects() {
    return this._selectedSubjects;
  }

  get recommendedSubjectsDataSource$(): Observable<SubjectDto[]> {
    if (!this._recommendedSubjectsDataSource$) {
      return of();
    }

    return this._recommendedSubjectsDataSource$;
  }

  constructor(
    private subjectService: SubjectService,
    private studentService: StudentService,
    private errorService: NotificationService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.init();
  }

  private init(): void {
    this.getStudentsStudyProgramAndItsSubjects();

    this._recommendedSubjectsDataSource$ = of();
  }

  private getStudentsStudyProgramAndItsSubjects() {
    this.studentService
      .getStudyProgramOfCurrentUser()
      .pipe(
        switchMap((studyProgram: StudyProgramDto) => {
          this._userStudyProgramId = studyProgram.id;
          return this.getAllSubjects(0, 10, this._userStudyProgramId);
        }),
        catchError((error: HttpErrorResponse) => {
          this.errorService.showError(error.error);
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
        }),
      )
      .subscribe((page) => {
        this._allSubjectsDataSource$ = of(page);
      });
  }

  private getAllSubjects(
    pageNumber: number,
    pageSize: number,
    studyProgramId: number,
  ): Observable<Page<SubjectExtendedDto>> {
    return this.subjectService
      .getSubjectsWithFocusByStudyProgramId(
        studyProgramId,
        pageNumber,
        pageSize,
      )
      .pipe(
        tap((page: Page<SubjectExtendedDto>) => {
          this.allSubjectsPageData.size = page.size;
          this.allSubjectsPageData.totalElements = page.totalElements;
          this.allSubjectsPageData.number = page.number;
          this.isLoadingAllSubjects = false;
        }),
        takeUntil(this._destroy$),
        catchError(() => {
          return of();
        }),
        shareReplay(1),
      );
  }

  public onPageChangeAllSubjects(event: PageEvent) {
    this.isLoadingAllSubjects = true;

    this._allSubjectsDataSource$ = this.getAllSubjects(
      event.pageIndex,
      event.pageSize,
      this._userStudyProgramId,
    );
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
  }

  public navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }

  public getSimilarSubjects() {
    this.isLoadingRecommendetSubjects = true;
    this._recommendedSubjectsDataSource$ = this.subjectService
      .getSimilarSubjects(this._selectedSubjects)
      .pipe(
        shareReplay(1), // Share the result of the HTTP request
        finalize(() => {
          this.isLoadingRecommendetSubjects = false;
          console.log('finished');
        }),
      );
  }

  public onSelectedSubjectsChanged($event: SubjectDto[]) {
    this._selectedSubjects = $event as SubjectExtendedDto[];
  }
}
