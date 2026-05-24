import {
  Directive,
  ViewContainerRef,
  OnInit,
  OnDestroy,
  ComponentRef,
  inject,
  EnvironmentInjector,
  createComponent,
  input,
} from '@angular/core';
import { TableCellRenderer, TableColumnDef, TableRow } from './generic-table.types';

/**
 * Directive to dynamically render cell components
 * Handles component injection and lifecycle
 */
@Directive({
  selector: '[appDynamicCellRenderer]',
  standalone: true,
})
export class DynamicCellRendererDirective<T extends TableRow = TableRow>
  implements OnInit, OnDestroy
{
  column = input<TableColumnDef<T>>();
  rowData = input<T>();
  rowIndex = input<number>();

  private componentRef?: ComponentRef<TableCellRenderer<T>>;
  private viewContainerRef = inject(ViewContainerRef);
  private environmentInjector = inject(EnvironmentInjector);

  ngOnInit(): void {
    this.renderComponent();
  }

  ngOnDestroy(): void {
    this.componentRef?.destroy();
  }

  private renderComponent(): void {
    // Clear any existing component
    this.viewContainerRef.clear();

    const column = this.column();
    if (!column) {
      throw new Error('Column definition is required to render cell.');
    }

    // Get the component to render
    const componentType = column.cellRenderer;
    if (!componentType) {
      throw new Error(`No cellRenderer specified for column ${column.field}.`);
    }

    // Create the component
    this.componentRef = createComponent(componentType, {
      environmentInjector: this.environmentInjector,
      elementInjector: this.viewContainerRef.injector,
    });

    // Get the value from the row data
    const value = this.getValue(this.rowData(), column);

    // Set inputs on the component instance
    this.componentRef.setInput('rowData', this.rowData);
    this.componentRef.setInput('value', value);
    this.componentRef.setInput('column', this.column);
    this.componentRef.setInput('rowIndex', this.rowIndex);

    // Attach to view
    this.viewContainerRef.insert(this.componentRef.hostView);
  }

  /**
   * Get value from row using field path (supports nested properties)
   */
  private getValue(row: T | undefined, column: TableColumnDef<T>): unknown {
    if (!column.field) return row;

    const fields = column.field.split('.');
    let value: unknown = row;

    for (const field of fields) {
      if (value === null || value === undefined) return null;
      value = (value as Record<string, unknown>)[field];
    }

    return value;
  }
}
