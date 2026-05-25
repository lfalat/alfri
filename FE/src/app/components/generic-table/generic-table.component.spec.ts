import { ComponentFixture, TestBed } from '@angular/core/testing';
import { signal } from '@angular/core';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { GenericTableComponent } from './generic-table.component';
import { TableConfig } from './generic-table.types';

describe('GenericTableComponent', () => {
  let component: GenericTableComponent<any>;
  let fixture: ComponentFixture<GenericTableComponent<any>>;

  interface TestData {
    id: number;
    name: string;
    email: string;
    active: boolean;
  }

  const mockData: TestData[] = [
    { id: 1, name: 'John Doe', email: 'john@example.com', active: true },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com', active: false },
    { id: 3, name: 'Bob Johnson', email: 'bob@example.com', active: true },
  ];

  const basicConfig: TableConfig<TestData> = {
    columns: [
      {
        id: 'name',
        header: 'Name',
        field: 'name',
        type: 'text',
        sortable: true,
      },
      {
        id: 'email',
        header: 'Email',
        field: 'email',
        type: 'text',
        sortable: true,
      },
      {
        id: 'active',
        header: 'Active',
        field: 'active',
        type: 'boolean',
      },
    ],
    enablePagination: true,
    pageSize: 10,
  };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GenericTableComponent, NoopAnimationsModule],
    }).compileComponents();

    fixture = TestBed.createComponent(GenericTableComponent<TestData>);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should display data in table', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.detectChanges();

    expect(component.dataSource.data).toEqual(mockData);
  });

  it('should update dataSource when data signal changes', () => {
    const dataSignal = signal(mockData);
    fixture.componentRef.setInput('data', dataSignal);
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.detectChanges();

    expect(component.dataSource.data.length).toBe(3);

    // Update signal
    dataSignal.set([
      ...mockData,
      { id: 4, name: 'Alice', email: 'alice@example.com', active: true },
    ]);
    fixture.detectChanges();

    expect(component.dataSource.data.length).toBe(4);
  });

  it('should compute visible columns correctly', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.detectChanges();

    const visibleColumns = component.visibleColumns();
    expect(visibleColumns).toEqual(['name', 'email', 'active']);
  });

  it('should compute displayed columns with selection', () => {
    const configWithSelection: TableConfig<TestData> = {
      ...basicConfig,
      enableSelection: true,
    };

    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(configWithSelection));
    fixture.detectChanges();

    const displayedColumns = component.displayedColumns();
    expect(displayedColumns).toContain('select');
    expect(displayedColumns).toContain('name');
  });

  it('should get nested values correctly', () => {
    const nestedData = {
      user: {
        profile: {
          name: 'John Doe',
        },
      },
    };

    const column = {
      id: 'userName',
      header: 'User Name',
      field: 'user.profile.name',
    };

    const value = component.getValue(nestedData, column);
    expect(value).toBe('John Doe');
  });

  it('should format values based on column type', () => {
    const dateColumn = {
      id: 'date',
      header: 'Date',
      field: 'date',
      type: 'date' as const,
    };

    const row = { date: new Date('2024-01-15') };
    const formatted = component.formatValue(row, dateColumn);
    expect(formatted).toBeTruthy();
    expect(formatted).toContain('2024');
  });

  it('should handle value formatter', () => {
    const column = {
      id: 'name',
      header: 'Name',
      field: 'name',
      valueFormatter: (value: string) => value.toUpperCase(),
    };

    const row = { name: 'john doe' };
    const formatted = component.formatValue(row, column);
    expect(formatted).toBe('JOHN DOE');
  });

  it('should apply filter correctly', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.detectChanges();

    component['applyFilter']('john');
    expect(component.dataSource.filteredData.length).toBe(2); // John Doe and Bob Johnson
  });

  it('should handle selection', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal({ ...basicConfig, enableSelection: true }));
    fixture.detectChanges();

    component.toggleRow(mockData[0]);
    expect(component.isSelected(mockData[0])).toBeTruthy();

    component.toggleRow(mockData[0]);
    expect(component.isSelected(mockData[0])).toBeFalsy();
  });

  it('should select all rows with masterToggle', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal({ ...basicConfig, enableSelection: true }));
    fixture.detectChanges();

    component.masterToggle();
    expect(component.isAllSelected()).toBeTruthy();
    expect(component.selection.selected.length).toBe(mockData.length);

    component.masterToggle();
    expect(component.isAllSelected()).toBeFalsy();
    expect(component.selection.selected.length).toBe(0);
  });

  it('should emit rowClick event', () => {
    const configWithRowClick: TableConfig<TestData> = {
      ...basicConfig,
      enableRowClick: true,
    };

    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(configWithRowClick));
    fixture.detectChanges();

    let clickedRow: TestData | null = null;
    component.rowClick.subscribe((event) => {
      clickedRow = event.row;
    });

    component.onRowClick(mockData[0], new MouseEvent('click'));
    expect(clickedRow).toEqual(mockData[0]);
  });

  it('should emit selectionChange event', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal({ ...basicConfig, enableSelection: true }));
    fixture.detectChanges();

    let selectedRows: TestData[] = [];
    component.selectionChange.subscribe((rows) => {
      selectedRows = rows;
    });

    component.toggleRow(mockData[0]);
    expect(selectedRows).toContain(mockData[0]);
  });

  it('should get badge class correctly', () => {
    const badgeColumn = {
      id: 'status',
      header: 'Status',
      field: 'status',
      type: 'badge' as const,
      badgeConfig: {
        colorMap: {
          active: 'success',
          inactive: 'default',
        },
      },
    };

    const row = { status: 'active' };
    const badgeClass = component.getBadgeClass(row, badgeColumn);
    expect(badgeClass).toContain('badge-success');
  });

  it('should use badge colorFn when provided', () => {
    const badgeColumn = {
      id: 'score',
      header: 'Score',
      field: 'score',
      type: 'badge' as const,
      badgeConfig: {
        colorFn: (value: number) => (value >= 90 ? 'success' : 'warning'),
      },
    };

    const highScoreRow = { score: 95 };
    const lowScoreRow = { score: 75 };

    const highScoreClass = component.getBadgeClass(highScoreRow, badgeColumn);
    const lowScoreClass = component.getBadgeClass(lowScoreRow, badgeColumn);

    expect(highScoreClass).toContain('badge-success');
    expect(lowScoreClass).toContain('badge-warning');
  });

  it('should handle actions correctly', () => {
    const actionClicked = vi.fn();

    const configWithActions: TableConfig<TestData> = {
      ...basicConfig,
      columns: [
        ...basicConfig.columns,
        {
          id: 'actions',
          header: 'Actions',
          type: 'actions',
          actionsConfig: [
            {
              id: 'edit',
              icon: 'edit',
              onClick: actionClicked,
            },
          ],
        },
      ],
    };

    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(configWithActions));
    fixture.detectChanges();

    const action = configWithActions.columns[3].actionsConfig![0];
    component.onActionClick(action, mockData[0], new MouseEvent('click'));

    expect(actionClicked).toHaveBeenCalledWith(mockData[0], expect.any(MouseEvent));
  });

  it('should check if action is disabled', () => {
    const action = {
      id: 'delete',
      icon: 'delete',
      onClick: () => {},
      disabled: (row: TestData) => row.id === 1,
    };

    expect(component.isActionDisabled(action, mockData[0])).toBeTruthy();
    expect(component.isActionDisabled(action, mockData[1])).toBeFalsy();
  });

  it('should check if action is hidden', () => {
    const action = {
      id: 'edit',
      icon: 'edit',
      onClick: () => {},
      hidden: (row: TestData) => !row.active,
    };

    expect(component.isActionHidden(action, mockData[0])).toBeFalsy(); // active = true
    expect(component.isActionHidden(action, mockData[1])).toBeTruthy(); // active = false
  });

  it('should get visible actions for a row', () => {
    const column = {
      id: 'actions',
      header: 'Actions',
      type: 'actions' as const,
      actionsConfig: [
        {
          id: 'edit',
          icon: 'edit',
          onClick: () => {},
        },
        {
          id: 'delete',
          icon: 'delete',
          onClick: () => {},
          hidden: (row: TestData) => !row.active,
        },
      ],
    };

    const visibleForActive = component.getVisibleActions(column, mockData[0]);
    expect(visibleForActive.length).toBe(2);

    const visibleForInactive = component.getVisibleActions(column, mockData[1]);
    expect(visibleForInactive.length).toBe(1);
  });

  it('should compute loading state correctly', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.componentRef.setInput('loading', signal(true));
    fixture.detectChanges();

    expect(component.isLoading()).toBeTruthy();
  });

  it('should compute has data correctly', () => {
    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(basicConfig));
    fixture.detectChanges();

    expect(component.hasData()).toBeTruthy();

    fixture.componentRef.setInput('data', signal([]));
    fixture.detectChanges();

    expect(component.hasData()).toBeFalsy();
  });

  it('should compute density class correctly', () => {
    const compactConfig: TableConfig<TestData> = {
      ...basicConfig,
      density: 'compact',
    };

    fixture.componentRef.setInput('data', signal(mockData));
    fixture.componentRef.setInput('config', signal(compactConfig));
    fixture.detectChanges();

    expect(component.densityClass()).toBe('density-compact');
  });

  it('should get column alignment class', () => {
    const leftColumn = { id: 'left', header: 'Left', align: 'left' as const };
    const centerColumn = {
      id: 'center',
      header: 'Center',
      align: 'center' as const,
    };
    const rightColumn = {
      id: 'right',
      header: 'Right',
      align: 'right' as const,
    };

    expect(component.getColumnAlignClass(leftColumn)).toBe('align-left');
    expect(component.getColumnAlignClass(centerColumn)).toBe('align-center');
    expect(component.getColumnAlignClass(rightColumn)).toBe('align-right');
  });

  it('should get column width style', () => {
    const column = {
      id: 'test',
      header: 'Test',
      width: '200px',
      minWidth: '100px',
      maxWidth: '300px',
    };

    const style = component.getColumnWidthStyle(column);
    expect(style['width']).toBe('200px');
    expect(style['min-width']).toBe('100px');
    expect(style['max-width']).toBe('300px');
  });
});
