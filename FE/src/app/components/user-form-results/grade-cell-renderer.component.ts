import { Component, Input } from '@angular/core';
import { NgClass } from '@angular/common';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table';

/**
 * Custom grade cell renderer for displaying grade badges
 * Shows grades with color-coded styling
 */
@Component({
  selector: 'app-grade-cell-renderer',
  standalone: true,
  imports: [NgClass],
  template: `
    <span class="grade-badge" [ngClass]="gradeClass">
      {{ value }}
    </span>
  `,
  styles: [
    `
      .grade-badge {
        display: inline-block;
        padding: 6px 16px;
        border-radius: 16px;
        font-weight: 600;
        font-size: 0.875rem;
        text-align: center;
        min-width: 40px;
      }

      .grade-excellent {
        background-color: #e8f5e9;
        color: #2e7d32;
      }

      .grade-very-good {
        background-color: #e3f2fd;
        color: #1565c0;
      }

      .grade-good {
        background-color: #fff3e0;
        color: #e65100;
      }

      .grade-satisfactory {
        background-color: #fff9c4;
        color: #f57f17;
      }

      .grade-sufficient {
        background-color: #ffebee;
        color: #c62828;
      }

      .grade-fail {
        background-color: #ffcdd2;
        color: #b71c1c;
        font-weight: 700;
      }
    `,
  ],
})
export class GradeCellRendererComponent<T extends TableRow = TableRow> implements TableCellRenderer<
  T,
  string
> {
  @Input() rowData!: T;
  @Input() value!: string;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  get gradeClass(): string {
    const gradeMap: Record<string, string> = {
      A: 'grade-excellent',
      B: 'grade-very-good',
      C: 'grade-good',
      D: 'grade-satisfactory',
      E: 'grade-sufficient',
      F: 'grade-fail',
      Fx: 'grade-fail',
    };
    return gradeMap[this.value] || '';
  }
}
