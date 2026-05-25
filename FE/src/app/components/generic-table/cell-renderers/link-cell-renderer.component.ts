import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { TableCellRenderer, TableRow, TableColumnDef } from '../generic-table.types';

/**
 * Link cell renderer component
 * Renders a clickable link that navigates to a specified route
 */
@Component({
  selector: 'app-link-cell-renderer',
  standalone: true,
  imports: [CommonModule],
  template: `
    <a
      class="text-decoration-none cursor-pointer"
      href="javascript:void(0)"
      (click)="onClick($event)"
    >
      {{ value }}
    </a>
  `,
  styles: [
    `
      a {
        cursor: pointer;
        color: #1976d2;
      }
      a:hover {
        text-decoration: underline !important;
      }
    `,
  ],
})
export class LinkCellRendererComponent<T extends TableRow = TableRow> implements TableCellRenderer<
  T,
  string
> {
  private readonly router = inject(Router);

  rowData!: T;
  value!: string;
  column!: TableColumnDef<T>;
  rowIndex!: number;

  onClick(event: Event): void {
    event.stopPropagation();

    // Get the navigation path from column metadata
    if (this.column.metadata?.routeBuilder) {
      const route = this.column.metadata.routeBuilder(this.rowData);
      this.router.navigate([route]);
    }
  }
}
