import {
  Component,
  input,
  output,
  viewChild,
  model,
  computed,
  effect,
  signal,
  AfterViewInit,
  Type,
  untracked,
  OnInit,
  inject,
  DestroyRef,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  MatTable,
  MatTableDataSource,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatCell,
  MatCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
} from '@angular/material/table';
import { MatSort, MatSortHeader, SortDirection } from '@angular/material/sort';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatFormField, MatLabel, MatPrefix } from '@angular/material/form-field';
import { MatInput } from '@angular/material/input';
import { MatIcon } from '@angular/material/icon';
import { MatCheckbox } from '@angular/material/checkbox';
import { MatTooltip } from '@angular/material/tooltip';
import { MatProgressSpinner } from '@angular/material/progress-spinner';
import { MatChipSet, MatChip, MatChipRemove } from '@angular/material/chips';
import { SelectionModel } from '@angular/cdk/collections';
import { debounce, Subject, timer } from 'rxjs';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';

import {
  TableConfig,
  TableColumnDef,
  TableCellContext,
  TableHeaderContext,
  TableCellRenderer,
  TableRow,
} from './generic-table.types';
import { TextCellRendererComponent } from '@components/generic-table/cell-renderers';
import { DynamicCellRendererDirective } from '@components/generic-table/dynamic-cell-renderer.directive';
import { Page } from '../../types';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-generic-table',
  standalone: true,
  imports: [
    CommonModule,
    MatTable,
    MatColumnDef,
    MatHeaderCell,
    MatHeaderCellDef,
    MatCell,
    MatCellDef,
    MatHeaderRow,
    MatHeaderRowDef,
    MatRow,
    MatRowDef,
    MatSort,
    MatSortHeader,
    MatPaginator,
    MatFormField,
    MatLabel,
    MatPrefix,
    MatInput,
    MatIcon,
    MatCheckbox,
    MatTooltip,
    MatProgressSpinner,
    MatChipSet,
    MatChip,
    MatChipRemove,
    DynamicCellRendererDirective,
  ],
  templateUrl: './generic-table.component.html',
  styleUrl: './generic-table.component.scss',
})
export class GenericTableComponent<T extends TableRow> implements AfterViewInit, OnInit {
  // ============ INPUTS (Signal-based) ============

  /**
   * Table data as a Page object for paged requests
   */
  data = input.required<Page<T>>();

  /**
   * Table configuration
   */
  config = input.required<TableConfig<T>>();

  /**
   * Loading state
   */
  loading = input<boolean>(false);

  // ============ OUTPUTS (Signal-based) ============

  /**
   * Row click event
   */
  rowClick = output<{ row: T; event: MouseEvent }>();

  /**
   * Selection change event
   */
  selectionChange = output<T[]>();

  /**
   * Sort change event
   */
  sortChange = output<{ active: string; direction: SortDirection }>();

  /**
   * Page change event
   */
  pageChange = output<PageEvent>();

  /**
   * Filter change event
   */
  filterChange = output<string>();

  /**
   * Column visibility change event
   */
  columnVisibilityChange = output<string[]>();

  /**
   * Export event
   */
  exportData = output<'csv' | 'excel' | 'pdf' | 'json'>();

  // ============ TWO-WAY BINDING (Model signals) ============

  /**
   * Selected rows (two-way binding)
   */
  selectedRows = model<T[]>([]);

  // ============ VIEW CHILDREN ============

  paginator = viewChild(MatPaginator);
  sort = viewChild(MatSort);

  // ============ INTERNAL STATE ============

  dataSource: MatTableDataSource<T> = new MatTableDataSource<T>();
  selection = new SelectionModel<T>(true, []);
  filterValue = signal<string>('');
  private readonly filterSubject = new Subject<string>();
  private readonly selectedIds = signal<unknown[]>([]); // Track selected IDs across data changes
  private readonly selectedItemsMap = signal<Map<unknown, T>>(new Map()); // Track full selected items
  private readonly destroyRef = inject(DestroyRef);

  // ============ COMPUTED SIGNALS ============

  /**
   * Visible columns based on configuration
   */
  visibleColumns = computed(() => {
    return this.config()
      .columns.filter((col) => col.visible !== false)
      .map((col) => col.id);
  });

  /**
   * Displayed columns including selection and actions
   */
  displayedColumns = computed(() => {
    const cols: string[] = [];

    // Add selection column if enabled
    if (this.config().enableSelection) {
      cols.push('select');
    }

    // Add visible columns
    cols.push(...this.visibleColumns());

    return cols;
  });

  /**
   * Effective page size
   */
  effectivePageSize = computed(() => {
    return this.config().pageSize ?? 10;
  });

  /**
   * Effective page size options
   */
  effectivePageSizeOptions = computed(() => {
    return this.config().pageSizeOptions ?? [5, 10, 25, 50, 100];
  });

  /**
   * Check if table is loading or has loading state
   */
  isLoading = computed(() => {
    return this.loading() || this.config().loading || false;
  });

  /**
   * Check if table has data
   */
  hasData = computed(() => {
    return this.dataSource.data.length > 0;
  });

  /**
   * Get table density class
   */
  densityClass = computed(() => {
    const density = this.config().density ?? 'normal';
    return `density-${density}`;
  });

  /**
   * Check if table is in server-side mode
   */
  isServerSide = computed(() => {
    return this.config().serverSide ?? true;
  });

  /**
   * Total elements from the Page object
   */
  totalElements = computed(() => {
    return this.data().totalElements;
  });

  /**
   * Total pages from the Page object
   */
  totalPages = computed(() => {
    return this.data().totalPages;
  });

  /**
   * Current page number from the Page object
   */
  currentPageNumber = computed(() => {
    return this.data().number;
  });

  /**
   * Current page size from the Page object
   */
  currentPageSize = computed(() => {
    return this.data().size;
  });

  /**
   * Get min-height style for table container
   */
  getTableContainerMinHeight = computed(() => {
    const minHeight = this.config().minHeight;
    if (!minHeight) {
      return '400px'; // Default min-height
    }
    return typeof minHeight === 'number' ? `${minHeight}px` : minHeight;
  });

  /**
   * All selected items across all pages
   * Returns the actual row objects that are currently tracked
   */
  allSelectedItems = computed(() => {
    const itemsMap = this.selectedItemsMap();
    return Array.from(itemsMap.values());
  });

  constructor() {
    // Update selection model mode (must run first, before data updates)
    effect(
      () => {
        const mode = this.config().selectionMode ?? 'multiple';

        // Create new selection model with correct mode
        this.selection = new SelectionModel<T>(mode === 'multiple', []);

        // Use untracked to read selectedIds without creating a dependency
        const currentSelectedIds = untracked(() => this.selectedIds());

        // If we have selected IDs and current data, restore selection
        if (currentSelectedIds.length > 0 && this.dataSource.data.length > 0) {
          const itemsToSelect = this.dataSource.data.filter((row) =>
            currentSelectedIds.includes(row.id),
          );
          itemsToSelect.forEach((row) => this.selection.select(row));
        }
      },
      { allowSignalWrites: true },
    );

    // Update dataSource when data signal changes, extracting content from Page
    effect(
      () => {
        const pageData = this.data();
        const newData = pageData.content;

        // Update the data source
        this.dataSource.data = newData;

        // Use untracked to read selection state without creating dependencies
        const selectedIdList = untracked(() => this.selectedIds());
        const shouldRestore = this.config().enableSelection && selectedIdList.length > 0;

        if (shouldRestore) {
          const newSelection = newData.filter((row) => selectedIdList.includes(row.id));

          // Update selection with new object references
          this.selection.clear();
          newSelection.forEach((row) => this.selection.select(row));

          // Update the map with new object references for items on this page
          const updatedMap = new Map(untracked(() => this.selectedItemsMap()));
          newSelection.forEach((row) => {
            updatedMap.set(row.id, row); // Update with new reference
          });
          this.selectedItemsMap.set(updatedMap);
        }

        // Sync paginator with Page data in server-side mode
        if (this.isServerSide()) {
          const paginatorInstance = this.paginator();
          if (paginatorInstance) {
            paginatorInstance.pageIndex = pageData.number;
            paginatorInstance.length = pageData.totalElements;
          }
        }
      },
      { allowSignalWrites: true },
    );

    // Setup custom sorting data accessor to handle field paths (only for client-side mode)
    effect(() => {
      if (!this.isServerSide()) {
        this.dataSource.sortingDataAccessor = (data: T, sortHeaderId: string) => {
          // Find the column definition for this sort header
          const column = this.config().columns.find((col) => col.id === sortHeaderId);
          if (!column?.field) {
            return '';
          }

          // Use custom sortAccessor if provided
          if (column.sortAccessor) {
            return column.sortAccessor(data);
          }

          // Get value using field path
          const value = this.getValue(data, column);

          // Convert to sortable value
          if (value === null || value === undefined) {
            return '';
          }

          // Return string or number for sorting
          return typeof value === 'string' || typeof value === 'number' ? value : String(value);
        };
      }
    });

    // Setup data source with custom filter predicate (only for client-side mode)
    effect(() => {
      if (!this.isServerSide()) {
        const configFn = this.config().filterPredicate;
        if (configFn) {
          this.dataSource.filterPredicate = configFn;
        } else {
          this.dataSource.filterPredicate = this.defaultFilterPredicate.bind(this);
        }
      }
    });
  }

  ngOnInit() {
    this.filterSubject
      .pipe(
        debounce(() => timer(this.config().filterDebounce ?? 500)),
        distinctUntilChanged(),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe((value) => {
        this.applyFilter(value);
      });
  }

  ngAfterViewInit(): void {
    const paginatorInstance = this.paginator();
    const sortInstance = this.sort();

    if (this.isServerSide()) {
      // Server-side mode: Don't connect paginator/sort to dataSource
      // They only emit events for the parent to handle
      if (paginatorInstance && this.config().enablePagination) {
        // Set initial values from Page object
        paginatorInstance.pageIndex = this.data().number;
        paginatorInstance.pageSize = this.data().size;
      }
    } else {
      // Client-side mode: Connect paginator/sort to dataSource
      if (paginatorInstance && this.config().enablePagination) {
        this.dataSource.paginator = paginatorInstance;
      }

      if (sortInstance && this.config().enableSorting) {
        this.dataSource.sort = sortInstance;
      }
    }

    // Apply initial sort if configured
    this.applyInitialSort();
  }

  /**
   * Apply initial sort configuration
   */
  private applyInitialSort(): void {
    const sortInstance = this.sort();
    const initialSort = this.config().initialSort;

    if (sortInstance && initialSort) {
      const { active, direction } = initialSort;
      sortInstance.active = active;
      sortInstance.direction = direction;
    }
  }

  // ============ HELPER METHODS ============

  /**
   * Get value from row using field path (supports nested properties)
   */
  getValue(row: T, column: TableColumnDef<T>): unknown {
    if (!column.field) return null;

    const fields = column.field.split('.');
    let value: unknown = row;

    for (const field of fields) {
      if (value === null || value === undefined) return null;
      value = (value as Record<string, unknown>)[field];
    }

    return value;
  }

  /**
   * Get the cell renderer component for a column
   * Returns the custom renderer or defaults to TextCellRendererComponent
   */
  getCellRenderer(column: TableColumnDef<T>): Type<TableCellRenderer<T, unknown>> {
    return column.cellRenderer ?? TextCellRendererComponent;
  }

  /**
   * Check if column has a custom cell renderer component
   */
  hasCellRenderer(column: TableColumnDef<T>): boolean {
    return !!column.cellRenderer;
  }

  /**
   * Check if column has a custom cell template
   */
  hasCellTemplate(column: TableColumnDef<T>): boolean {
    return !!column.cellTemplate;
  }

  /**
   * Get cell context for template rendering
   */
  getCellContext(row: T, column: TableColumnDef<T>, rowIndex: number): TableCellContext<T> {
    return {
      $implicit: row,
      column,
      rowIndex,
      value: this.getValue(row, column),
    };
  }

  /**
   * Get header context for template rendering
   */
  getHeaderContext(column: TableColumnDef<T>): TableHeaderContext<T> {
    return {
      column,
      sortDirection: this.sort()?.active === column.id ? this.sort()?.direction : undefined,
    };
  }

  /**
   * Get CSS classes for cell
   */
  getCellClass(row: T, column: TableColumnDef<T>): string | string[] {
    if (!column.cellClass) return '';

    if (typeof column.cellClass === 'function') {
      return column.cellClass(row);
    }

    return column.cellClass;
  }

  /**
   * Get CSS classes for header cell
   */
  getHeaderClass(column: TableColumnDef<T>): string | string[] {
    return column.headerClass ?? '';
  }

  /**
   * Default filter predicate
   */
  private defaultFilterPredicate(data: T, filter: string): boolean {
    const normalizedFilter = filter.toLowerCase();
    const columns = this.config().columns.filter((col) => col.filterable !== false);

    return columns.some((column) => {
      const value = this.getValue(data, column);
      if (value === null || value === undefined) return false;
      return String(value).toLowerCase().includes(normalizedFilter);
    });
  }

  /**
   * Apply filter to data source (client-side) or emit event (server-side)
   */
  private applyFilter(filterValue: string): void {
    if (this.isServerSide()) {
      // In server-side mode, just emit the filter change event
      // Parent component is responsible for fetching filtered data
      this.filterChange.emit(filterValue);
    } else {
      // In client-side mode, apply filter to dataSource
      this.dataSource.filter = filterValue.trim().toLowerCase();

      if (this.dataSource.paginator) {
        this.dataSource.paginator.firstPage();
      }

      this.filterChange.emit(filterValue);
    }
  }

  /**
   * Handle filter input
   */
  onFilterChange(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    this.filterValue.set(value);
    this.filterSubject.next(value);
  }

  /**
   * Handle row click
   */
  onRowClick(row: T, event: MouseEvent): void {
    if (this.config().enableRowClick) {
      this.rowClick.emit({ row, event });
    }
  }

  // ============ SELECTION METHODS ============

  /**
   * Whether the number of selected elements matches the total number of rows
   * (or maxSelection limit if configured)
   */
  isAllSelected(): boolean {
    const numSelected = this.selection.selected.length;
    const numRows = this.dataSource.data.length;
    const maxSelection = this.config().maxSelection;

    // Only return true if there are rows
    if (numRows === 0) {
      return false;
    }

    // If maxSelection is set, check if we've selected up to the max limit
    if (maxSelection) {
      // Check total selected across ALL pages
      const totalSelected = this.selectedIds().length;

      // If we've reached the global max, check if all items on current page that can be selected are selected
      if (totalSelected >= maxSelection) {
        // All current page items that are in the global selection should be selected
        const currentPageSelectedCount = this.dataSource.data.filter((row) =>
          this.selectedIds().includes(row.id),
        ).length;
        return currentPageSelectedCount === numSelected && numSelected > 0;
      }

      // Otherwise, check if we've selected up to the remaining available slots on this page
      const remainingSlots = maxSelection - totalSelected + numSelected;
      const maxSelectableOnPage = Math.min(remainingSlots, numRows);
      return numSelected === maxSelectableOnPage;
    }

    // Otherwise, check if all rows are selected
    return numSelected === numRows;
  }

  /**
   * Selects all rows if they are not all selected; otherwise clear selection
   */
  masterToggle(): void {
    // Check if we should select or deselect
    // If any item from current page is selected, we deselect all from current page
    // Otherwise, we select up to max limit
    const hasAnySelected = this.selection.hasValue();

    if (hasAnySelected) {
      // Clear all selections from current page
      this.selection.clear();
    } else {
      // Select rows up to max limit
      const maxSelection = this.config().maxSelection;

      if (maxSelection) {
        // Check how many items are already selected across ALL pages
        const totalAlreadySelected = this.selectedIds().length;
        const remainingSlots = maxSelection - totalAlreadySelected;

        // Only select if we have remaining slots
        if (remainingSlots > 0) {
          const rowsToSelect = this.dataSource.data.slice(0, remainingSlots);
          this.selection.clear();
          rowsToSelect.forEach((row) => this.selection.select(row));
        }
      } else {
        // No max limit, select all on current page
        this.selection.clear();
        this.dataSource.data.forEach((row) => this.selection.select(row));
      }
    }
    this.onSelectionChange();
  }

  /**
   * Toggle row selection
   */
  toggleRow(row: T): void {
    const maxSelection = this.config().maxSelection;
    const isCurrentlySelected = this.selection.isSelected(row);

    // If trying to select and max limit is reached, prevent selection
    if (!isCurrentlySelected && maxSelection && this.selection.selected.length >= maxSelection) {
      // Don't allow selection
      return;
    }

    this.selection.toggle(row);
    this.onSelectionChange();
  }

  /**
   * Check if row is selected
   */
  isSelected(row: T): boolean {
    return this.selection.isSelected(row);
  }

  /**
   * Check if a row can be selected (based on max selection limit)
   */
  canSelectRow(row: T): boolean {
    const maxSelection = this.config().maxSelection;
    const isCurrentlySelected = this.selection.isSelected(row);

    // If already selected, it can always be deselected
    if (isCurrentlySelected) {
      return true;
    }

    // If no max limit, can always select
    if (!maxSelection) {
      return true;
    }

    // Check total selected across ALL pages (not just current page)
    const totalSelected = this.selectedIds().length;
    return totalSelected < maxSelection;
  }

  /**
   * Handle selection change
   */
  private onSelectionChange(): void {
    const selected = this.selection.selected; // Items selected on CURRENT page only

    // Get existing map to preserve selections from other pages
    const existingMap = new Map(untracked(() => this.selectedItemsMap()));
    const currentPageIds = new Set(this.dataSource.data.map((row) => row.id));

    // Remove items from current page that are no longer selected
    for (const [id] of existingMap) {
      if (currentPageIds.has(id) && !selected.some((row) => row.id === id)) {
        existingMap.delete(id);
      }
    }

    // Add newly selected items from current page
    selected.forEach((row) => {
      existingMap.set(row.id, row);
    });

    // Update signals with merged selection
    const allSelectedIds = Array.from(existingMap.keys());
    this.selectedIds.set(allSelectedIds);
    this.selectedItemsMap.set(existingMap);

    // Emit all selected items (across all pages)
    const allSelected = Array.from(existingMap.values());
    this.selectedRows.set(allSelected);
    this.selectionChange.emit(allSelected);
  }

  /**
   * Remove a selected item by its ID (used by chips)
   */
  removeSelectedItem(id: unknown): void {
    // Remove from selectedIds
    const currentIds = this.selectedIds();
    const newIds = currentIds.filter((itemId) => itemId !== id);
    this.selectedIds.set(newIds);

    // Remove from selectedItemsMap
    const newMap = new Map(this.selectedItemsMap());
    newMap.delete(id);
    this.selectedItemsMap.set(newMap);

    // If item is on current page, deselect from SelectionModel
    const itemOnCurrentPage = this.dataSource.data.find((row) => row.id === id);
    if (itemOnCurrentPage) {
      this.selection.deselect(itemOnCurrentPage);
    }

    // Emit updated selection
    const allSelected = Array.from(newMap.values());
    this.selectedRows.set(allSelected);
    this.selectionChange.emit(allSelected);
  }

  /**
   * Get display label for a selected item chip
   * Uses the first visible column's value or falls back to id
   */
  getChipLabel(item: T): string {
    const firstColumn = this.config().columns.find((col) => col.visible !== false);
    if (firstColumn) {
      const value = this.getValue(item, firstColumn);
      return value ? String(value) : String(item.id);
    }
    return String(item.id);
  }

  // ============ SORT METHODS ============

  /**
   * Handle sort change
   */
  onSortChange(): void {
    const sortInstance = this.sort();
    if (sortInstance) {
      this.sortChange.emit({
        active: sortInstance.active,
        direction: sortInstance.direction,
      });
    }
  }

  // ============ PAGINATION METHODS ============

  /**
   * Handle page change
   */
  onPageChange(event: PageEvent): void {
    this.pageChange.emit(event);
  }

  // ============ EXPORT METHODS ============

  /**
   * Export data to CSV
   */
  exportToCsv(): void {
    this.exportData.emit('csv');
  }

  /**
   * Get column alignment class
   */
  getColumnAlignClass(column: TableColumnDef<T>, isHeader: boolean = false): string {
    const align = isHeader ? (column.headerAlign ?? column.align) : column.align;
    return align ? `align-${align}` : 'align-left';
  }

  /**
   * Get column width style
   */
  getColumnWidthStyle(column: TableColumnDef<T>): Record<string, string> {
    const style: Record<string, string> = {};

    if (column.width) {
      style['width'] = column.width;
    }
    if (column.minWidth) {
      style['min-width'] = column.minWidth;
    }
    if (column.maxWidth) {
      style['max-width'] = column.maxWidth;
    }

    return style;
  }

  /**
   * Track by function for columns
   */
  trackByColumnId(index: number, column: TableColumnDef<T>): string {
    return column.id;
  }

  /**
   * Track by function for rows
   * Uses the required 'id' property for optimal performance
   */
  trackByRow(index: number, row: T): unknown {
    return row.id;
  }
}
