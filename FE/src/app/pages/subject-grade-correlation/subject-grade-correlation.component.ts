import { Component, computed, inject, OnDestroy, OnInit, signal } from '@angular/core';
import {
  BehaviorSubject,
  forkJoin,
  map,
  Observable,
  of,
  ReplaySubject,
  switchMap,
  takeUntil,
  Subscription,
  Subject,
} from 'rxjs';
import { SubjectGradeCorrelationService } from '@services/subject-grade-correlation.service';
import { NgApexchartsModule } from 'ng-apexcharts';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { FormsModule } from '@angular/forms';
import {
  MatTab,
  MatTabChangeEvent,
  MatTabGroup,
  MatTabLabel,
} from '@angular/material/tabs';
import { Operator } from '@enums/operator';
import { AsyncPipe } from '@angular/common';
import { SubjectGradeCorrelationDetailComponent } from '@components/subject-grade-correlation-detail/subject-grade-correlation-detail.component';
import { MatIcon } from '@angular/material/icon';
import {
  ApexChartOptions,
  StudyProgramDto,
  SubjectGradeCorrelation,
} from '../../types';
import { UserService } from '@services/user.service';
import { StudyProgramService } from '@services/study-program.service';
import { AuthRole } from '@enums/auth-role';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';

@Component({
  selector: 'app-subject-grade-correlation',
  standalone: true,
  imports: [
    NgApexchartsModule,
    MatProgressSpinner,
    FormsModule,
    MatFormFieldModule,
    MatSelectModule,
    MatTabGroup,
    MatTab,
    AsyncPipe,
    SubjectGradeCorrelationDetailComponent,
    MatIcon,
    MatTabLabel,
  ],
  templateUrl: './subject-grade-correlation.component.html',
  styleUrls: ['./subject-grade-correlation.component.scss'],
})
export class SubjectGradeCorrelationComponent implements OnInit, OnDestroy {
  get chartOptions(): ApexChartOptions {
    return this._chartOptions;
  }

  get heatmapDataLoaded$(): Observable<boolean> {
    return this._heatmapDataLoaded$.asObservable();
  }

  highCorrelationData$: Observable<SubjectGradeCorrelation[]> | null = null;
  lowCorrelationData$: Observable<SubjectGradeCorrelation[]> | null = null;
  noCorrelationData$: Observable<SubjectGradeCorrelation[]> | null = null;

  studyPrograms$!: Observable<StudyProgramDto[]>;

  private readonly _heatmapDataLoaded$: BehaviorSubject<boolean> =
    new BehaviorSubject(false);

  private readonly _chartOptions: ApexChartOptions;
  private readonly _destroy$: ReplaySubject<void> = new ReplaySubject(1);
  private readonly subjectGradeCorrelationService = inject(
    SubjectGradeCorrelationService,
  );

  private readonly userService = inject(UserService);
  private readonly studyProgramService = inject(StudyProgramService);

  // studyProgramId from user's profile (for students this will always be set)
  studyProgramId = computed(() => this.userService.userData()?.studyProgramId);

  // whether current user is a student
  isStudent = computed(
    () =>
      this.userService
        .userData()
        ?.roles?.some((r) => r.name === AuthRole.STUDENT) ?? false,
  );

  // selected study program for fetching correlations (null until chosen for non-students)
  selectedStudyProgramId = signal<number | null>(null);

  // track currently selected tab so we can reload it when study program changes
  private currentTabIndex = 0;

  // subscription for the heatmap request so we can cancel a previous one when changing study program
  private heatmapSubscription?: Subscription;

  // notify subscribers when study program changes so template async pipes can unsubscribe safely
  private readonly _studyProgramChange$: Subject<void> = new Subject<void>();

  constructor() {
    this._chartOptions = {
      series: [],
      chart: {
        type: 'heatmap',
        height: '800px',
      },
      dataLabels: {
        enabled: true,
      },
      colors: ['#008FFB'],
      title: {},
      plotOptions: {
        heatmap: {
          enableShades: false,
          reverseNegativeShade: false,
          colorScale: {
            inverse: false,
            ranges: [
              { from: -1, to: -0.75, color: '#4A148C' },
              { from: -0.75, to: -0.5, color: '#1976D2' },
              { from: -0.5, to: -0.25, color: '#388E3C' },
              { from: -0.25, to: 0, color: '#AEEA00' },
              { from: 0, to: 0.25, color: '#AEEA00' },
              { from: 0.25, to: 0.5, color: '#388E3C' },
              { from: 0.5, to: 0.75, color: '#1976D2' },
              { from: 0.75, to: 1, color: '#4A148C' },
            ],
          },
        },
      },
      xAxis: { categories: [] },
      responsive: [
        {
          breakpoint: 768,
          options: {
            chart: {
              width: '100%',
            },
            legend: {
              position: 'bottom',
            },
            plotOptions: {
              bar: {
                horizontal: true,
              },
            },
          },
        },
        {
          breakpoint: 480,
          options: {
            chart: {
              width: '100%',
              height: 300,
            },
            legend: {
              position: 'bottom',
            },
            plotOptions: {
              bar: {
                horizontal: true,
              },
            },
          },
        },
      ],
    };
  }

  public onTabChange(event: MatTabChangeEvent) {
    this.currentTabIndex = event.index; // track current tab
    switch (event.index) {
      case 0:
        if (!this._heatmapDataLoaded$.value) {
          this.loadHeatmapData();
        }
        break;
      case 1:
        if (!this.highCorrelationData$) {
          this.loadHighCorrelationData();
        }
        break;
      case 2:
        if (!this.lowCorrelationData$) {
          this.loadLowCorrelationData();
        }
        break;
      case 3:
        if (!this.noCorrelationData$) {
          this.loadNoCorrelationData();
        }
        break;
    }
  }

  ngOnInit() {
    // If current user is a student, auto-select their study program and load data
    if (this.isStudent()) {
      const spId = this.studyProgramId();
      if (spId) {
        this.selectedStudyProgramId.set(spId);
        this.loadHeatmapData();
      }
    } else {
      // For other roles, fetch available study programs for the dropdown
      this.studyPrograms$ = this.studyProgramService.getAll();
    }
  }

  ngOnDestroy() {
    this._destroy$.next();
    this._destroy$.complete();
    // ensure we also unsubscribe any running heatmap request
    this.heatmapSubscription?.unsubscribe();
    // complete study program change notifier
    this._studyProgramChange$.complete();
  }

  public onStudyProgramChange(selectedId: number | null) {
    if (!selectedId) {
      return;
    }

    // signal any template-bound observables to unsubscribe before we replace them
    this._studyProgramChange$.next();

    // reset UI state for new selection
    this.selectedStudyProgramId.set(selectedId);
    this._heatmapDataLoaded$.next(false);
    this.chartOptions.series = [];

    // clear previously loaded observables safely so async pipe has null instead of undefined
    this.highCorrelationData$ = null;
    this.lowCorrelationData$ = null;
    this.noCorrelationData$ = null;

    // Cancel any ongoing heatmap request before starting a new one
    this.heatmapSubscription?.unsubscribe();

    // Reload the currently visible tab so user sees updated data immediately
    switch (this.currentTabIndex) {
      case 0:
        this.loadHeatmapData();
        break;
      case 1:
        this.loadHighCorrelationData();
        break;
      case 2:
        this.loadLowCorrelationData();
        break;
      case 3:
        this.loadNoCorrelationData();
        break;
      default:
        this.loadHeatmapData();
    }
  }

  private loadHeatmapData(): void {
    const spId = this.selectedStudyProgramId();
    if (!spId) {
      // no study program selected yet
      return;
    }

    // clear existing series before fetching
    this.chartOptions.series = [];

    // Cancel any previously running heatmap request to avoid race conditions
    this.heatmapSubscription?.unsubscribe();

    this.heatmapSubscription = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(spId)
      .pipe(takeUntil(this._studyProgramChange$), takeUntil(this._destroy$))
      .subscribe((data: SubjectGradeCorrelation[]) => {
        this.chartOptions.series = [];

        // Collect all unique subjects from both firstSubject and secondSubject
        const allSubjectsMap = new Map<number, { id: number; name: string }>();
        data.forEach((correlation) => {
          allSubjectsMap.set(correlation.firstSubject.id, {
            id: correlation.firstSubject.id,
            name: correlation.firstSubject.name,
          });
          allSubjectsMap.set(correlation.secondSubject.id, {
            id: correlation.secondSubject.id,
            name: correlation.secondSubject.name,
          });
        });

        const allSubjects = Array.from(allSubjectsMap.values()).sort((a, b) =>
          a.name.localeCompare(b.name),
        );

        // Create a map for quick lookup of correlations
        const correlationMap = new Map<string, number>();
        data.forEach((correlation) => {
          const key = `${correlation.firstSubject.id}-${correlation.secondSubject.id}`;
          correlationMap.set(key, correlation.correlation);
        });

        // Build series for each subject
        allSubjects.forEach((subject) => {
          const dataPoints: { x: string; y: string }[] = [];

          allSubjects.forEach((otherSubject) => {
            let correlationValue: number;

            if (subject.id === otherSubject.id) {
              // Diagonal: self-correlation is always 1
              correlationValue = 1;
            } else {
              // Look up the correlation from the data
              const key = `${subject.id}-${otherSubject.id}`;
              correlationValue = correlationMap.get(key) ?? 0;
            }

            dataPoints.push({
              x: otherSubject.name,
              y: correlationValue.toFixed(2),
            });
          });

          this.chartOptions.series.push({
            name: subject.name,
            data: dataPoints,
            group: subject.name,
          });
        });

        this._heatmapDataLoaded$.next(true);
      });
  }

  private loadHighCorrelationData() {
    const spId = this.selectedStudyProgramId();
    if (!spId) {
      return;
    }

    this.highCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(spId, 0.75, Operator.GREATER_OR_EQUAL)
      .pipe(takeUntil(this._studyProgramChange$), takeUntil(this._destroy$));
  }

  private loadLowCorrelationData() {
    const spId = this.selectedStudyProgramId();
    if (!spId) {
      return;
    }

    this.lowCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(spId, -0.75, Operator.LESS_OR_EQUAL)
      .pipe(takeUntil(this._studyProgramChange$), takeUntil(this._destroy$));
  }

  private loadNoCorrelationData() {
    const spId = this.selectedStudyProgramId();
    if (!spId) {
      return;
    }

    this.noCorrelationData$ = this.subjectGradeCorrelationService
      .getSubjectGradeCorrelation(spId, -0.05, Operator.GREATER_OR_EQUAL)
      .pipe(
        takeUntil(this._studyProgramChange$),
        takeUntil(this._destroy$),
        switchMap(
          (negativeNeutralCorrelationData: SubjectGradeCorrelation[]) => {
            const positiveNeutralCorrelation$ =
              this.subjectGradeCorrelationService.getSubjectGradeCorrelation(
                spId,
                0.05,
                Operator.LESS_OR_EQUAL,
              );
            return forkJoin([
              positiveNeutralCorrelation$,
              of(negativeNeutralCorrelationData),
            ]);
          },
        ),
        map(([positiveNeutralCorrelation, negativeNeutralCorrelationData]) => {
          return [
            ...positiveNeutralCorrelation,
            ...negativeNeutralCorrelationData,
          ];
        }),
      );
  }
}
