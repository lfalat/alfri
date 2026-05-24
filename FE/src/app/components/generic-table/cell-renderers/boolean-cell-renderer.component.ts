import { Component, Input } from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

/**
 * Boolean cell renderer - displays checkmark/cross icons
 * Can be customized with different icons and colors
 */
@Component({
  selector: 'app-boolean-cell-renderer',
  standalone: true,
  imports: [MatIcon],
  template: ` <mat-icon [class]="iconClass">{{ iconName }}</mat-icon> `,
  styles: [
    `
      mat-icon {
        font-size: 20px;
        width: 20px;
        height: 20px;

        &.true-icon {
          color: var(--color-success, #4caf50);
        }

        &.false-icon {
          color: var(--color-error, #f44336);
        }
      }
    `,
  ],
})
export class BooleanCellRendererComponent<
  T extends TableRow = TableRow,
> implements TableCellRenderer<T, boolean> {
  @Input() rowData!: T;
  @Input() value!: boolean;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  @Input() trueIcon: string = 'check_circle';
  @Input() falseIcon: string = 'cancel';

  get iconName(): string {
    return this.value ? this.trueIcon : this.falseIcon;
  }

  get iconClass(): string {
    return this.value ? 'true-icon' : 'false-icon';
  }
}
