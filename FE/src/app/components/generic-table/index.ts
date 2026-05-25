/**
 * GenericTableComponent - Component-based table with dynamic cell renderers
 *
 * Main exports for the generic table module
 */

// Main component
export { GenericTableComponent } from './generic-table.component';

// Types and interfaces
export type {
  TableRow,
  PagedTableRow,
  TableConfig,
  TableColumnDef,
  TableCellRenderer,
  TableCellContext,
  TableHeaderContext,
  TableSelectionEvent,
  TableRowClickEvent,
  TableSortEvent,
  TablePageEvent,
  TableHeaderConfig,
} from './generic-table.types';

// Built-in cell renderers
export {
  TextCellRendererComponent,
  BadgeCellRendererComponent,
  DateCellRendererComponent,
  NumberCellRendererComponent,
  BooleanCellRendererComponent,
  ActionsCellRendererComponent,
  LinkCellRendererComponent,
  PercentageCellRendererComponent,
  type TableAction,
} from './cell-renderers';

// Directive (usually not needed by consumers, but exported for advanced use cases)
export { DynamicCellRendererDirective } from './dynamic-cell-renderer.directive';
