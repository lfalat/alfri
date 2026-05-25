import { TemplateRef, Type } from '@angular/core';
import { SortDirection } from '@angular/material/sort';

/**
 * Base interface for table row data
 * All table data must have a unique identifier for optimal performance and selection
 */
export interface TableRow {
  id: unknown;
}

/**
 * Base interface for paged table row data
 * Extends TableRow to support pagination from backend
 */
export type PagedTableRow = TableRow;

/**
 * Base interface that all cell renderer components must implement
 * This provides a contract for custom column renderers
 */
export interface TableCellRenderer<T extends TableRow = TableRow, V = unknown> {
  /**
   * The row data for this cell
   */
  rowData: T;

  /**
   * The specific value for this cell (extracted from rowData using field path)
   */
  value: V;

  /**
   * The column configuration
   */
  column: TableColumnDef<T>;

  /**
   * The row index in the current page
   */
  rowIndex: number;
}

/**
 * Context passed to cell templates
 */
export interface TableCellContext<T extends TableRow = TableRow> {
  $implicit: T; // Row data
  column: TableColumnDef<T>;
  rowIndex: number;
  value: unknown; // Resolved field value
}

/**
 * Context passed to header templates
 */
export interface TableHeaderContext<T extends TableRow = TableRow> {
  column: TableColumnDef<T>;
  sortDirection?: SortDirection;
}

/**
 * Column definition for the generic table
 * Uses component injection for maximum flexibility
 */
export interface TableColumnDef<T extends TableRow> {
  /**
   * Unique identifier for the column
   * Used as matColumnDef value and for data access
   */
  id: string;

  /**
   * Display label for column header
   * Supports i18n keys or plain text
   */
  header: string;

  /**
   * Property path in data object (supports nested: 'user.profile.name')
   * If not provided, entire row is passed to renderer as value
   */
  field?: string;

  /**
   * Custom component to render cell content
   * Component must implement TableCellRenderer interface
   *
   * @example
   * ```typescript
   * {
   *   id: 'status',
   *   header: 'Status',
   *   field: 'status',
   *   cellRenderer: StatusBadgeComponent
   * }
   * ```
   */
  cellRenderer: Type<TableCellRenderer<T>>;

  /**
   * Custom template for cell content (alternative to cellRenderer)
   * Use this for simple inline templates
   */
  cellTemplate?: TemplateRef<TableCellContext<T>>;

  /**
   * Custom template for header cell
   */
  headerTemplate?: TemplateRef<TableHeaderContext<T>>;

  /**
   * Enable sorting for this column
   * @default false
   */
  sortable?: boolean;

  /**
   * Custom sort comparator function
   * If not provided, uses default Material sorting
   */
  sortComparator?: (a: T, b: T, direction: SortDirection) => number;

  /**
   * Sort accessor function for complex data structures
   * Extracts the sortable value from row data
   */
  sortAccessor?: (row: T) => string | number;

  /**
   * Include this column in global filter
   * @default true
   */
  filterable?: boolean;

  /**
   * Column is visible by default
   * @default true
   */
  visible?: boolean;

  /**
   * Column cannot be hidden by user
   * @default false
   */
  sticky?: boolean;

  /**
   * CSS width (e.g., '200px', '15%', 'auto')
   */
  width?: string;

  /**
   * Minimum width
   */
  minWidth?: string;

  /**
   * Maximum width
   */
  maxWidth?: string;

  /**
   * Text alignment in cells
   * @default 'left'
   */
  align?: 'left' | 'center' | 'right';

  /**
   * Header alignment (if different from cell alignment)
   */
  headerAlign?: 'left' | 'center' | 'right';

  /**
   * CSS class(es) to apply to cells in this column
   */
  cellClass?: string | string[] | ((row: T) => string | string[]);

  /**
   * CSS class(es) to apply to header cell
   */
  headerClass?: string | string[];

  /**
   * Tooltip text for header
   */
  headerTooltip?: string;

  /**
   * Function to generate tooltip for cells
   */
  cellTooltip?: (row: T, value: unknown) => string;

  /**
   * Additional metadata to pass to cell renderer
   * Can be used for custom renderers that need extra configuration
   */
  metadata?: any;
}

/**
 * Selection change event
 */
export interface TableSelectionEvent<T> {
  selectedRows: T[];
  selectedIndices: number[];
}

/**
 * Row click event
 */
export interface TableRowClickEvent<T> {
  row: T;
  index: number;
  event: MouseEvent;
}

/**
 * Sort change event
 */
export interface TableSortEvent {
  active: string;
  direction: SortDirection;
}

/**
 * Page change event
 */
export interface TablePageEvent {
  pageIndex: number;
  pageSize: number;
  length: number;
}

/**
 * Configuration for table header section
 */
export interface TableHeaderConfig {
  /**
   * Show header section
   * @default false
   */
  show?: boolean;

  /**
   * Header title
   */
  title?: string;

  /**
   * Header icon (Material icon name)
   */
  icon?: string;

  /**
   * Custom header template (overrides title/icon)
   */
  template?: TemplateRef<void>;

  /**
   * Enable global search input in header
   * @default false
   */
  enableSearch?: boolean;

  /**
   * Search placeholder text
   * @default 'Search...'
   */
  searchPlaceholder?: string;
}

/**
 * Main configuration interface for GenericTableComponent
 */
export interface TableConfig<T extends TableRow = TableRow> {
  /**
   * Column definitions array
   */
  columns: TableColumnDef<T>[];

  // === Sorting Configuration ===

  /**
   * Enable sorting globally
   * Individual columns still need sortable: true
   * @default false
   */
  enableSorting?: boolean;

  /**
   * Initial sort state
   */
  initialSort?: {
    active: string;
    direction: SortDirection;
  };

  // === Pagination Configuration ===

  /**
   * Enable server-side pagination, sorting, and filtering
   * When true, the table expects Page<T> data and emits events for data changes
   * When false, uses client-side MatTableDataSource for all operations
   * @default true (since we now use Page<T> input)
   */
  serverSide?: boolean;

  /**
   * Enable pagination
   * @default true
   */
  enablePagination?: boolean;

  /**
   * Page size options
   * @default [5, 10, 25, 50]
   */
  pageSizeOptions?: number[];

  /**
   * Default page size
   * @default 10
   */
  pageSize?: number;

  /**
   * Show first/last buttons on paginator
   * @default true
   */
  showFirstLastButtons?: boolean;

  // === Filtering Configuration ===

  /**
   * Custom filter predicate
   * Overrides default filtering logic
   */
  filterPredicate?: (data: T, filter: string) => boolean;

  /**
   * Debounce time for filter input (ms)
   * @default 300
   */
  filterDebounce?: number;

  // === Selection Configuration ===

  /**
   * Enable row selection
   * @default false
   */
  enableSelection?: boolean;

  /**
   * Selection mode
   * @default 'multiple'
   */
  selectionMode?: 'single' | 'multiple';

  /**
   * Highlight selected rows
   * @default true
   */
  highlightSelection?: boolean;

  /**
   * Maximum number of rows that can be selected
   * Only applicable when enableSelection is true
   * @default undefined (no limit)
   */
  maxSelection?: number;

  // === Interaction Configuration ===

  /**
   * Enable row click events
   * @default false
   */
  enableRowClick?: boolean;

  /**
   * Enable column visibility toggle
   * @default false
   */
  enableColumnToggle?: boolean;

  // === Appearance Configuration ===

  /**
   * Table density/size
   * @default 'normal'
   */
  density?: 'compact' | 'normal' | 'comfortable';

  /**
   * CSS class for table container
   */
  tableClass?: string | string[];

  /**
   * Enable sticky header
   * @default false
   */
  stickyHeader?: boolean;

  /**
   * Minimum height for table container (prevents layout jumping during data load)
   * Can be a number (in pixels) or a CSS string (e.g., '400px', '50vh')
   * @default '400px'
   */
  minHeight?: number | string;

  /**
   * Table header configuration
   */
  header?: TableHeaderConfig;

  // === State Configuration ===

  /**
   * Show loading spinner
   * @default false
   */
  loading?: boolean;

  /**
   * Custom loading template
   */
  loadingTemplate?: TemplateRef<void>;

  /**
   * Show empty state when no data
   * @default true
   */
  showEmptyState?: boolean;

  /**
   * Custom empty state template
   */
  emptyTemplate?: TemplateRef<void>;

  /**
   * Empty state message
   * @default 'No data available'
   */
  emptyMessage?: string;
}
