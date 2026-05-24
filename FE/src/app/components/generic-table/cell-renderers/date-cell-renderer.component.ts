import { Component, Input } from '@angular/core';
import { DatePipe } from '@angular/common';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

/**
 * Date cell renderer with configurable formatting
 * Uses Angular DatePipe for localization support
 */
@Component({
  selector: 'app-date-cell-renderer',
  standalone: true,
  imports: [DatePipe],
  template: ` <span>{{ value | date: dateFormat }}</span> `,
})
export class DateCellRendererComponent<T extends TableRow = TableRow> implements TableCellRenderer<
  T,
  Date | string
> {
  @Input() rowData!: T;
  @Input() value!: Date | string;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  /**
   * Date format - can be configured per column
   * @default 'short'
   */
  @Input() dateFormat: string = 'short';
}
