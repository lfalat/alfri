import { Observable } from 'rxjs';
import { Page, SubjectDto } from '../../types';
import { MatPaginator, PageEvent, MatPaginatorModule } from '@angular/material/paginator';
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
  MatTable,
  MatTableDataSource,
  MatTableModule,
} from '@angular/material/table';
import { MatProgressBar } from '@angular/material/progress-bar';
import { Component, computed, effect, input, output, signal } from '@angular/core';
import { MatCheckbox } from '@angular/material/checkbox';

@Component({
  selector: 'app-subjects-table',
  standalone: true,
  imports: [
    MatTableModule,
    MatPaginatorModule,
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatCell,
    MatHeaderRow,
    MatRow,
    MatProgressBar,
    MatPaginator,
    MatHeaderCellDef,
    MatCellDef,
    MatHeaderRowDef,
    MatRowDef,
    MatCheckbox,
  ],
  templateUrl: './subjects-table.component.html',
  styleUrls: ['./subjects-table.component.scss'],
})
export class SubjectsTableComponent {
  // Inputs (signal-based)
  dataSourceInput = input<MatTableDataSource<SubjectDto>>();
  legacyDataSource$ = input<
    SubjectDto[] | MatTableDataSource<SubjectDto> | Observable<SubjectDto[]>
  >(); // legacy binding support
  pageData = input.required<Page<SubjectDto>>();
  isLoading = input<boolean>(true);
  displayFullInfo = input<boolean>(true);
  isSelectable = input<boolean>(false);
  maxSelectableSubjects = input<number>(Infinity);
  isPageable = input<boolean>(true);
  isScrollable = input<boolean>(false);

  // Outputs (signal-based) - still EventEmitter under the hood but created via output()
  pageChange = output<PageEvent>();
  subjectDetailNavigate = output<string>();
  selectedSubjects = output<SubjectDto[]>();
  // Internal signals
  readonly internalDataSource = signal<MatTableDataSource<SubjectDto>>(
    new MatTableDataSource<SubjectDto>([]),
  );
  private readonly selectedSubjectsMap = signal<Map<string, SubjectDto>>(new Map());
  readonly showLoader = signal<boolean>(false);
  private loadingTimeout: ReturnType<typeof setTimeout> | null = null;

  // Computed: list of columns
  columnsToDisplay = computed(() => {
    const full = this.displayFullInfo();
    const selectable = this.isSelectable();

    const baseColumns = full
      ? ['name', 'code', 'abbreviation', 'obligation', 'recommendedYear', 'semester']
      : ['name', 'abbreviation', 'obligation'];

    return selectable ? ['select', ...baseColumns] : baseColumns;
  });

  // Computed: selected subjects array & count
  selectedSubjectsList = computed(() => Array.from(this.selectedSubjectsMap().values()));
  selectedSubjectsCount = computed(() => this.selectedSubjectsMap().size);

  constructor() {
    // Effect: sync dataSourceInput with internalDataSource
    effect(() => {
      const input = this.dataSourceInput();
      if (input) {
        this.internalDataSource.set(input);
      } else {
        // If no dataSourceInput, use pageData content
        const page = this.pageData();
        if (page?.content) {
          const ds = new MatTableDataSource<SubjectDto>(page.content);
          this.internalDataSource.set(ds);
        }
      }
    });

    // Effect: delayed loading indicator (only show after 200ms)
    effect(() => {
      const loading = this.isLoading();

      // Clear any existing timeout
      if (this.loadingTimeout) {
        clearTimeout(this.loadingTimeout);
        this.loadingTimeout = null;
      }

      if (loading) {
        // Start a timeout to show loader after 200ms
        this.loadingTimeout = setTimeout(() => {
          this.showLoader.set(true);
        }, 200);
      } else {
        // Immediately hide loader when not loading
        this.showLoader.set(false);
      }
    });

    // Effect: emit selected subjects whenever list changes
    effect(() => {
      this.selectedSubjects.emit(this.selectedSubjectsList());
    });
  }

  onPageChange(event: PageEvent) {
    if (!this.isPageable()) {
      return;
    }
    this.pageChange.emit(event);
  }

  navigateToSubjectDetail(code: string) {
    this.subjectDetailNavigate.emit(code);
  }

  toggleSelection(subject: SubjectDto): void {
    this.selectedSubjectsMap.update((map) => {
      const has = map.has(subject.code);
      if (has) {
        map.delete(subject.code);
        return new Map(map);
      }
      // Add new if below maximum
      if (this.selectedSubjectsCount() < this.maxSelectableSubjects()) {
        map.set(subject.code, subject);
      }
      return new Map(map);
    });
  }

  isDisabled(subject: SubjectDto): boolean {
    return (
      !this.selectedSubjectsMap().has(subject.code) &&
      this.selectedSubjectsCount() >= this.maxSelectableSubjects()
    );
  }

  isSelected(subject: SubjectDto): boolean {
    return this.selectedSubjectsMap().has(subject.code);
  }

  trackByCode = (_: number, item: SubjectDto) => item.code;
}
