import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TableCellRenderer, TableRow, TableColumnDef } from '../generic-table.types';

/**
 * Percentage cell renderer component
 * Renders numeric values as percentages with color coding
 */
@Component({
  selector: 'app-percentage-cell-renderer',
  standalone: true,
  imports: [CommonModule],
  template: ` <span [ngClass]="getColorClass()" class="percentage-value"> {{ value }} % </span> `,
  styles: [
    `
      .percentage-value {
        font-weight: 500;
        padding: 4px 8px;
        border-radius: 4px;
        display: inline-block;
      }

      .excellent {
        color: #2e7d32;
        background-color: #e8f5e9;
      }

      .good {
        color: #558b2f;
        background-color: #f1f8e9;
      }

      .average {
        color: #f57c00;
        background-color: #fff3e0;
      }

      .below-average {
        color: #e64a19;
        background-color: #fbe9e7;
      }

      .poor {
        color: #c62828;
        background-color: #ffebee;
      }
    `,
  ],
})
export class PercentageCellRendererComponent<
  T extends TableRow = TableRow,
> implements TableCellRenderer<T, number> {
  @Input() rowData!: T;
  @Input() value!: number;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  getColorClass(): string {
    if (this.value === null || this.value === undefined) {
      return '';
    }

    const numValue = Number(this.value);

    if (numValue >= 80) {
      return 'excellent';
    } else if (numValue >= 60) {
      return 'good';
    } else if (numValue >= 40) {
      return 'average';
    } else if (numValue >= 20) {
      return 'below-average';
    } else {
      return 'poor';
    }
  }
}
