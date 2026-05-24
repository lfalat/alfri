import { Component, Input, Output, EventEmitter } from '@angular/core';
import { MatIconButton } from '@angular/material/button';
import { MatIcon } from '@angular/material/icon';
import { MatTooltip } from '@angular/material/tooltip';
import { TableCellRenderer, TableColumnDef, TableRow } from '../generic-table.types';

export interface TableAction<T = unknown> {
  id: string;
  icon?: string;
  label?: string;
  tooltip?: string;
  color?: 'primary' | 'accent' | 'warn';
  onClick?: (row: T, event: MouseEvent) => void;
  disabled?: boolean | ((row: T) => boolean);
  hidden?: boolean | ((row: T) => boolean);
}

/**
 * Actions cell renderer for row-level action buttons
 * Displays icon buttons with tooltips
 *
 * Usage:
 * 1. Set cellRenderer: ActionsCellRendererComponent in column config
 * 2. Pass actions array via column configuration or component input
 */
@Component({
  selector: 'app-actions-cell-renderer',
  standalone: true,
  imports: [MatIconButton, MatIcon, MatTooltip],
  template: `
    <div class="actions-container">
      @for (action of visibleActions; track action.id) {
        <button
          mat-icon-button
          [color]="action.color"
          [disabled]="isActionDisabled(action)"
          [matTooltip]="action.tooltip || ''"
          (click)="handleAction(action, $event)"
        >
          @if (action.icon) {
            <mat-icon>{{ action.icon }}</mat-icon>
          } @else {
            {{ action.label }}
          }
        </button>
      }
    </div>
  `,
  styles: [
    `
      .actions-container {
        display: flex;
        gap: 4px;
        align-items: center;
      }
    `,
  ],
})
export class ActionsCellRendererComponent<T extends TableRow> implements TableCellRenderer<
  T,
  never
> {
  @Input() rowData!: T;
  @Input() value!: never;
  @Input() column!: TableColumnDef<T>;
  @Input() rowIndex!: number;

  /**
   * Actions to display - can be passed directly or via column config
   */
  @Input() actions: TableAction<T>[] = [];

  @Output() actionClick = new EventEmitter<{ action: TableAction<T>; row: T; event: MouseEvent }>();

  get visibleActions(): TableAction<T>[] {
    return this.actions.filter((action) => {
      if (typeof action.hidden === 'function') {
        return !action.hidden(this.rowData);
      }
      return !action.hidden;
    });
  }

  isActionDisabled(action: TableAction<T>): boolean {
    if (typeof action.disabled === 'function') {
      return action.disabled(this.rowData);
    }
    return action.disabled || false;
  }

  handleAction(action: TableAction<T>, event: MouseEvent): void {
    event.stopPropagation();

    if (action.onClick) {
      action.onClick(this.rowData, event);
    }

    this.actionClick.emit({ action, row: this.rowData, event });
  }
}
