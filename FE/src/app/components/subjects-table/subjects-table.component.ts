import {
  Component,
  EventEmitter,
  Input,
  OnDestroy,
  OnInit,
  Output,
} from '@angular/core';
import { Observable, Subject, takeUntil } from 'rxjs';
import { Page, SubjectDto } from '../../types';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
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
} from '@angular/material/table';
import { MatProgressBar } from '@angular/material/progress-bar';
import { AsyncPipe, NgClass, NgIf } from '@angular/common';
import { MatCheckbox } from '@angular/material/checkbox';
import { SelectionModel } from '@angular/cdk/collections';

@Component({
  selector: 'app-subjects-table',
  standalone: true,
  imports: [
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
    NgIf,
    MatCheckbox,
    AsyncPipe,
    NgClass,
  ],
  templateUrl: './subjects-table.component.html',
  styleUrl: './subjects-table.component.scss',
})
export class SubjectsTableComponent implements OnInit, OnDestroy {
  @Input() dataSource$!: Observable<SubjectDto[]>;
  @Input() pageData!: Page<SubjectDto>;
  @Input() isLoading = false;
  @Input() displayFullInfo = true;
  @Input() isSelectable = false;
  @Input() maxSelectableSubjects = Infinity;
  @Input() isPageable = true;
  @Input() isScrollable = false;

  @Output() pageChange = new EventEmitter<PageEvent>();
  @Output() subjectDetailNavigate = new EventEmitter<string>();
  @Output() selectedSubjects: EventEmitter<SubjectDto[]> = new EventEmitter<
    SubjectDto[]
  >();

  private readonly _destroy$: Subject<void> = new Subject();
  private _columnsToDisplay!: string[];
  private _selection = new SelectionModel<SubjectDto>(true, []);
  // public selectedSubjectsMap: Map<SubjectDto, boolean> = new Map();
  public selectedSubjectsMap: Map<string, SubjectDto> = new Map();

  public get columnsToDisplay(): string[] {
    return this._columnsToDisplay;
  }

  ngOnInit(): void {
    if (this.displayFullInfo) {
      this._columnsToDisplay = [
        'name',
        'code',
        'abbreviation',
        'obligation',
        'recommendedYear',
        'semester',
      ];
    } else {
      this._columnsToDisplay = ['name', 'abbreviation', 'obligation'];
    }

    if (this.isSelectable) {
      this._columnsToDisplay.unshift('select');
    }

    this._selection.changed.pipe(takeUntil(this._destroy$)).subscribe(() => {
      this.selectedSubjects.emit(this._selection.selected);
    });
  }

  ngOnDestroy(): void {
    this._destroy$.next();
    this._destroy$.complete();
  }

  onPageChange(event: PageEvent) {
    if (!this.isPageable) {
      return;
    }

    this.pageChange.emit(event);
  }

  navigateToSubjectDetail(code: string) {
    this.subjectDetailNavigate.emit(code);
  }

  public toggleSelection(selectedSubject: SubjectDto): void {
    if (this.selectedSubjectsMap.get(selectedSubject.code)) {
      this.selectedSubjectsMap.delete(selectedSubject.code);
    } else if (
      Array.from(this.selectedSubjectsMap.values()).length <
      this.maxSelectableSubjects
    ) {
      this.selectedSubjectsMap.set(selectedSubject.code, selectedSubject);
    }

    const selectedSubjects = Array.from(this.selectedSubjectsMap.values());

    this.selectedSubjects.emit(selectedSubjects);
  }

  public getSelectedSubjectsCount(): number {
    return Array.from(this.selectedSubjectsMap.values()).filter((v) => v)
      .length;
  }
}
