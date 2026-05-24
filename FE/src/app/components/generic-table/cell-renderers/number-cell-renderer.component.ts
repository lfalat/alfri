import { Component, Input } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

/**
 * Number cell renderer with configurable formatting
 * Uses Angular DecimalPipe for localization support
 */
@Component({
  selector: 'app-number-cell-renderer',
  standalone: true,
  imports: [DecimalPipe],
  template: ` <span>{{ value | number: numberFormat }}</span> `,
})
export class NumberCellRendererComponent<
  T extends TableRow = TableRow,
> implements TableCellRenderer<T, number> {
  @Input() rowData!: T;
  @Input() value!: number;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  /**
   * Number format - can be configured per column
   * @default '1.0-2'
   */
  @Input() numberFormat: string = '1.0-2';
}
