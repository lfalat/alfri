/**
 * Built-in cell renderers for GenericTableComponent
 *
 * These provide common rendering patterns out of the box.
 * Users can use these or create their own by implementing TableCellRenderer interface.
 */

// Types
export type { TableCellRenderer, TableRow } from '../generic-table.types';

// Cell Renderers
export { TextCellRendererComponent } from './text-cell-renderer.component';
export { BadgeCellRendererComponent } from './badge-cell-renderer.component';
export { DateCellRendererComponent } from './date-cell-renderer.component';
export { NumberCellRendererComponent } from './number-cell-renderer.component';
export { ActionsCellRendererComponent, type TableAction } from './actions-cell-renderer.component';
export { BooleanCellRendererComponent } from './boolean-cell-renderer.component';
export { LinkCellRendererComponent } from './link-cell-renderer.component';
export { PercentageCellRendererComponent } from './percentage-cell-renderer.component';
