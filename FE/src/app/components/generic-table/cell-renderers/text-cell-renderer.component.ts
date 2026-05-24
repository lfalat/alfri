import { Component, Input } from '@angular/core';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

/**
 * Simple text cell renderer
 * Displays plain text with optional formatting
 */
@Component({
  selector: 'app-text-cell-renderer',
  standalone: true,
  template: ` <span [class]="getCellClass()">{{ displayValue }}</span> `,
  styles: [
    `
      :host {
        display: block;
        width: 100%;
      }
    `,
  ],
})
export class TextCellRendererComponent<T extends TableRow = TableRow> implements TableCellRenderer<
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

  getCellClass(): string {
    if (!this.column.cellClass) {
      return '';
    }

    if (typeof this.column.cellClass === 'function') {
      const result = this.column.cellClass(this.rowData);
      return Array.isArray(result) ? result.join(' ') : result;
    }

    return Array.isArray(this.column.cellClass)
      ? this.column.cellClass.join(' ')
      : this.column.cellClass;
  }
}
