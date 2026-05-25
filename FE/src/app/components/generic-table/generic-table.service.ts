import { Injectable } from '@angular/core';
import { TableColumnDef, TableRow } from './generic-table.types';

/**
 * Service for generic table utilities like export, column management, etc.
 */
@Injectable({
  providedIn: 'root',
})
export class GenericTableService {
  /**
   * Export data to CSV format
   */
  exportToCsv<T extends TableRow>(
    data: T[],
    columns: TableColumnDef<T>[],
    filename: string = 'export.csv',
  ): void {
    if (!data || data.length === 0) {
      console.warn('No data to export');
      return;
    }

    const visibleColumns = columns.filter((col) => col.visible !== false && col.field);

    // Create CSV headers
    const headers = visibleColumns.map((col) => this.escapeCsvValue(col.header));
    const csvContent = [headers.join(',')];

    // Create CSV rows
    data.forEach((row) => {
      const values = visibleColumns.map((col) => {
        const value = this.getNestedValue(row, col.field!);
        return this.escapeCsvValue(this.formatCsvValue(value));
      });
      csvContent.push(values.join(','));
    });

    // Download file
    this.downloadFile(csvContent.join('\n'), filename, 'text/csv;charset=utf-8;');
  }

  /**
   * Export data to JSON format
   */
  exportToJson<T>(data: T[], filename: string = 'export.json'): void {
    if (!data || data.length === 0) {
      console.warn('No data to export');
      return;
    }

    const jsonContent = JSON.stringify(data, null, 2);
    this.downloadFile(jsonContent, filename, 'application/json;charset=utf-8;');
  }

  /**
   * Get value from nested object path
   */
  private getNestedValue(obj: unknown, path: string): unknown {
    const fields = path.split('.');
    let value: unknown = obj;

    for (const field of fields) {
      if (value === null || value === undefined) return null;
      if (typeof value === 'object' && value !== null) {
        value = (value as Record<string, unknown>)[field];
      } else {
        return null;
      }
    }
    return value;
  }

  /**
   * Escape CSV value (handle commas, quotes, newlines)
   */
  private escapeCsvValue(value: unknown): string {
    if (value === null || value === undefined) return '';

    const stringValue = String(value);
    // If value contains comma, quote, or newline, wrap in quotes and escape existing quotes
    if (stringValue.includes(',') || stringValue.includes('"') || stringValue.includes('\n')) {
      return `"${stringValue.replace(/"/g, '""')}"`;
    }

    return stringValue;
  }

  /**
   * Format value for CSV export
   */
  private formatCsvValue(value: unknown): string {
    if (value === null || value === undefined) return '';
    if (value instanceof Date) return value.toISOString();
    if (typeof value === 'object') return JSON.stringify(value);
    return String(value);
  }

  /**
   * Download file to browser
   */
  private downloadFile(content: string, filename: string, mimeType: string): void {
    const blob = new Blob([content], { type: mimeType });
    const link = document.createElement('a');

    if (link.download !== undefined) {
      const url = URL.createObjectURL(blob);
      link.setAttribute('href', url);
      link.setAttribute('download', filename);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);
    }
  }

  /**
   * Get visible column IDs
   */
  getVisibleColumnIds<T extends TableRow>(columns: TableColumnDef<T>[]): string[] {
    return columns.filter((col) => col.visible !== false).map((col) => col.id);
  }

  /**
   * Toggle column visibility
   */
  toggleColumnVisibility<T extends TableRow>(
    columns: TableColumnDef<T>[],
    columnId: string,
  ): TableColumnDef<T>[] {
    return columns.map((col) => {
      if (col.id === columnId && !col.sticky) {
        return { ...col, visible: !col.visible };
      }
      return col;
    });
  }

  /**
   * Reorder columns
   */
  reorderColumns<T extends TableRow>(
    columns: TableColumnDef<T>[],
    previousIndex: number,
    currentIndex: number,
  ): TableColumnDef<T>[] {
    const result = [...columns];
    const [removed] = result.splice(previousIndex, 1);
    result.splice(currentIndex, 0, removed);
    return result;
  }

  /**
   * Save column configuration to localStorage
   */
  saveColumnConfig<T extends TableRow>(tableId: string, columns: TableColumnDef<T>[]): void {
    const config = columns.map((col) => ({
      id: col.id,
      visible: col.visible,
    }));

    localStorage.setItem(`table-config-${tableId}`, JSON.stringify(config));
  }

  /**
   * Load column configuration from localStorage
   */
  loadColumnConfig<T extends TableRow>(
    tableId: string,
    columns: TableColumnDef<T>[],
  ): TableColumnDef<T>[] {
    const configJson = localStorage.getItem(`table-config-${tableId}`);

    if (!configJson) return columns;

    try {
      const config = JSON.parse(configJson) as Array<{
        id: string;
        visible?: boolean;
      }>;

      return columns.map((col) => {
        const saved = config.find((c) => c.id === col.id);
        if (saved) {
          return { ...col, visible: saved.visible };
        }
        return col;
      });
    } catch (e) {
      console.error('Failed to load table config', e);
      return columns;
    }
  }

  /**
   * Clear saved column configuration
   */
  clearColumnConfig(tableId: string): void {
    localStorage.removeItem(`table-config-${tableId}`);
  }
}
