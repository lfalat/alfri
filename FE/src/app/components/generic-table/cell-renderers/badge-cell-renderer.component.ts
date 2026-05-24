import { Component, Input } from '@angular/core';
import { NgClass } from '@angular/common';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

/**
 * Badge/chip cell renderer for status indicators
 * Example usage: grade badges, status chips, tags
 *
 * Users can extend this or create their own badge renderer
 */
@Component({
  selector: 'app-badge-cell-renderer',
  standalone: true,
  imports: [NgClass],
  template: `
    <span class="badge" [ngClass]="badgeClass">
      {{ displayValue }}
    </span>
  `,
  styles: [
    `
      .badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.875rem;
        font-weight: 500;
        text-align: center;
        white-space: nowrap;
      }
    `,
  ],
})
export class BadgeCellRendererComponent<T extends TableRow = TableRow> implements TableCellRenderer<
  T,
  string
> {
  @Input() rowData!: T;
  @Input() value!: string;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  get displayValue(): string {
    return this.value?.toString() ?? '';
  }

  get badgeClass(): string | string[] {
    if (typeof this.column.cellClass === 'function') {
      return this.column.cellClass(this.rowData);
    }
    return this.column.cellClass || '';
  }
}
