import { Component, inject, OnInit } from '@angular/core';
import { DepartmentDto, SubjectDto, TeacherDto, UserDto } from '../../types';
import {
  MAT_DIALOG_DATA,
  MatDialogActions,
  MatDialogContent,
  MatDialogRef,
  MatDialogTitle,
} from '@angular/material/dialog';
import { DepartmentService } from '@services/department.service';
import { TeacherService } from '@services/teacher.service';
import { AdminService } from '@services/admin.service';
import { FormsModule } from '@angular/forms';

import { MatButton } from '@angular/material/button';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { MatOption, MatSelect } from '@angular/material/select';
import {
  MatCell,
  MatCellDef,
  MatColumnDef,
  MatHeaderCell,
  MatHeaderCellDef,
  MatHeaderRow,
  MatHeaderRowDef,
  MatRow,
  MatRowDef,
  MatTable,
} from '@angular/material/table';
import { MatCheckbox, MatCheckboxChange } from '@angular/material/checkbox';
import { forkJoin } from 'rxjs';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-change-subjects-modal',
  standalone: true,
  imports: [
    FormsModule,
    MatDialogContent,
    MatButton,
    MatDialogActions,
    MatDialogTitle,
    MatFormField,
    MatSelect,
    MatOption,
    MatTable,
    MatHeaderRow,
    MatHeaderCell,
    MatRow,
    MatCell,
    MatCheckbox,
    MatLabel,
    MatCellDef,
    MatHeaderCellDef,
    MatColumnDef,
    MatRowDef,
    MatHeaderRowDef,
  ],
  templateUrl: './change-subjects-modal.component.html',
  styleUrl: './change-subjects-modal.component.scss',
})
export class ChangeSubjectsModalComponent implements OnInit {
  selectedUser: UserDto | undefined;
  selectedTeacher: TeacherDto | null = null;
  selectedTeacherSubjects: SubjectDto[] = [];
  availableSubjects: SubjectDto[] = [];
  availableDepartments: DepartmentDto[] = [];
  selectedTeacherDepartment: DepartmentDto | null = null;
  displayedColumns: string[] = ['name', 'assigned'];
  selectedDepartmentId = -1;

  private readonly ts = inject(TeacherService);
  private readonly ds = inject(DepartmentService);
  private readonly adminService = inject(AdminService);
  private readonly dialogRef = inject(MatDialogRef<ChangeSubjectsModalComponent>);
  public readonly data = inject(MAT_DIALOG_DATA);

  ngOnInit(): void {
    this.selectedUser = this.data.user;
    this.fetchTeacherData(this.data.userId);
  }

  fetchTeacherData(userId: number): void {
    this.ts.getTeacherSubjects(userId).subscribe((subjects) => {
      this.selectedTeacherSubjects = subjects;
    });

    forkJoin([
      this.ts.getTeacherById(userId),
      this.ds.getAllDepartments(),
      this.adminService.getAllSubjects(),
    ]).subscribe({
      next: ([teacher, departments, availableSubjects]) => {
        this.selectedTeacher = teacher;
        this.selectedTeacherDepartment = teacher.department;
        this.selectedDepartmentId = teacher.department.id;

        console.log(teacher.department); // Optional logging for the teacher's department
        console.log(departments); // Optional logging for departments

        this.availableDepartments = departments;
        this.availableSubjects = availableSubjects;
      },
      error: (error) => {
        console.error(error);
      },
    });
  }

  onSubjectToggle(subject: SubjectDto, event: MatCheckboxChange): void {
    const checked = event.checked;
    if (!checked) {
      this.selectedTeacherSubjects = this.selectedTeacherSubjects.filter(
        (s) => s.code !== subject.code,
      );
      this.availableSubjects.push(subject);
      return;
    }
    this.selectedTeacherSubjects.push(subject);
  }

  saveTeacherSubjects(): void {
    if (!(this.selectedTeacher && this.selectedDepartmentId)) {
      return;
    }
    const subjectCodes = this.selectedTeacherSubjects.map((s) => s.code);

    this.ts
      .updateTeacherSubjects(this.selectedTeacher.userId, subjectCodes)
      .pipe(
        switchMap(() => {
          if (!(this.selectedTeacher && this.selectedDepartmentId)) {
            return []; // Return an empty observable to exit if conditions are not met
          }
          return this.ts.updateTeacherDepartment(
            this.selectedTeacher.userId,
            this.selectedDepartmentId,
          );
        }),
      )
      .subscribe({
        next: () => {
          this.dialogRef.close();
        },
        error: (error) => {
          console.error(error);
        },
      });
  }

  closeSubjectModal(): void {
    this.dialogRef.close();
  }

  isSubjectAssigned(subject: SubjectDto): boolean {
    return this.selectedTeacherSubjects.some((s) => s.code === subject.code);
  }
}
