import { Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { map, Observable, Subject, takeUntil } from 'rxjs';
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
  MatTable
} from '@angular/material/table';
import { MatProgressBar } from '@angular/material/progress-bar';
import { AsyncPipe, NgIf } from '@angular/common';
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
    AsyncPipe
  ],
  templateUrl: './subjects-table.component.html',
  styleUrl: './subjects-table.component.scss'
})
export class SubjectsTableComponent implements OnInit, OnDestroy {
  @Input() dataSource$!: Observable<SubjectDto[]>;
  @Input() pageData!: Page<SubjectDto>;
  @Input() isLoading = false;
  @Input() displayFullInfo = true;
  @Input() isSelectable = false;
  @Input() maxSelectableSubjects = Infinity;
  @Input() isPageable = true;

  @Output() pageChange = new EventEmitter<PageEvent>();
  @Output() subjectDetailNavigate = new EventEmitter<string>();
  @Output() selectedSubjects: EventEmitter<SubjectDto[]> = new EventEmitter<SubjectDto[]>();

  private readonly _destroy$: Subject<void> = new Subject();
  private _columnsToDisplay!: string[];
  private _selection = new SelectionModel<SubjectDto>(true, []);
  public selectedSubjectsMap: Map<string, boolean> = new Map();

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
      this._columnsToDisplay = [
        'name',
        'abbreviation',
        'obligation',
      ];
    }

    if (this.isSelectable) {
      this._columnsToDisplay.unshift('select');
    }

    this._selection.changed.subscribe(() => {
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

  public toggleSelection(row: SubjectDto): void {
    if (this.selectedSubjectsMap.get(row.code)) {
      this.selectedSubjectsMap.set(row.code, false);
    } else if (Array.from(this.selectedSubjectsMap.values()).filter(v => v).length < this.maxSelectableSubjects) {
      this.selectedSubjectsMap.set(row.code, true);
    }
    this.dataSource$.pipe(
      takeUntil(this._destroy$),
      map(subjects => Array.from(this.selectedSubjectsMap.entries())
        .filter(([, isSelected]) => isSelected)
        .map(([code]) => subjects.find(subject => subject.code === code)))
    ).subscribe((selelectedSubjects) => {
      const validSubjects = selelectedSubjects.filter((subject): subject is SubjectDto => subject !== undefined);
      this.selectedSubjects.emit(validSubjects);
    });
  }

  public getSelectedSubjectsCount(): number {
    return Array.from(this.selectedSubjectsMap.values()).filter(v => v).length;
  }
}
