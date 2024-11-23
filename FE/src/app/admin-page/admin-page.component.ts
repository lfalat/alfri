import { Component, OnInit } from '@angular/core';
import { AdminService } from '../services/admin.service';
import { UserService } from '../services/user.service';
import { NotificationService } from '../services/notification.service';
import { DepartmentService } from '../services/department.service';
import { DepartmentDto, Role, SubjectDto, TeacherDto, UserDto } from '../types';
import { NgForOf, NgIf } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TeacherService } from '../services/teacher.service';

@Component({
  selector: 'app-admin',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.scss'],
  imports: [
    NgForOf,
    NgIf,
    FormsModule
  ],
  standalone: true
})
export class AdminPageComponent implements OnInit {
  users: UserDto[] = [];
  availableSubjects: SubjectDto[] = [];
  showSubjectModal = false;
  selectedUser: UserDto | undefined = undefined;
  selectedTeacher: TeacherDto | null = null;
  selectedTeacherId: number | null = null;
  selectedTeacherSubjects: SubjectDto[] = [];
  selectedTeacherDepartment: DepartmentDto | null = null;

  availableRoles: Role[] = [];
  availableDepartments: DepartmentDto[] = [];


  constructor(private as: AdminService, private us: UserService, private ns: NotificationService,
              private ds: DepartmentService, private ts: TeacherService) {}

  ngOnInit(): void {
    this.fetchData();
  }

  fetchData(): void {
    this.as.getAllUsers().subscribe((data) => {
      this.users = data;
    });
    this.us.getRoles().subscribe((roles) => {
      this.availableRoles = roles;
    });
    this.ds.getAllDepartments().subscribe(departments => {
      this.availableDepartments = departments;
    });
    this.loadAllSubjects();
  }

  userHasRole(user: UserDto, role: Role): boolean {
    return user.roles.some((userRole: Role) => userRole.id === role.id);
  }

  onRoleToggle(user: UserDto, role: Role, event: Event): void {
    const isAdd = (event.target as HTMLInputElement).checked;

    this.as.updateUserRole(user.userId, role, isAdd).subscribe(() => {
      if (isAdd) {
        user.roles.push(role);
      } else {
        user.roles = user.roles.filter((userRole: Role) => userRole.id !== role.id);
      }
    });
  }


  deleteUser(userId: number): void {
    if (confirm('Are you sure you want to delete this user?')) {
      this.as.deleteUser(userId).subscribe(() => {
        this.users = this.users.filter((user) => user.userId !== userId);
      });
    }
  }

  loadAllSubjects(): void {
    this.as.getAllSubjects().subscribe((subjects) => {
      this.availableSubjects = subjects;
    });
  }

  openSubjectModal(userId: number): void {
    this.selectedUser = this.users.find(user => user.userId === userId && this.userHasRole(user, {
      id: 2,
      name: 'teacher'
    }));

    if (this.selectedUser) {
      this.ts.getTeacherSubjects(userId).subscribe((subjects) => {
        this.selectedTeacherSubjects = subjects;
      });
      this.ts.getTeacherById(userId).subscribe((teacher) => {
        this.selectedTeacher = teacher;
        this.selectedTeacherDepartment = teacher.department;
      });
      // this.ts.getTeacherDepartment(userId).subscribe((department) => {
      //   this.selectedTeacherDepartment = department;
      // });
      this.showSubjectModal = true;
    }
  }

  onAssignedSubjectToggle(subject: SubjectDto, event: Event): void {
    const checked = (event.target as HTMLInputElement).checked;

    if (!checked) {
      this.selectedTeacherSubjects = this.selectedTeacherSubjects.filter(s => s.code !== subject.code);
      this.availableSubjects.push(subject);
    }
    this.availableSubjects = this.availableSubjects.filter(
      subject => !this.selectedTeacherSubjects.some(s => s.code === subject.code)
    );
  }

  onUnassignedSubjectToggle(subject: SubjectDto, event: Event): void {
    const checked = (event.target as HTMLInputElement).checked;

    if (checked) {
      this.selectedTeacherSubjects.push(subject);
    } else {
      this.selectedTeacherSubjects = this.selectedTeacherSubjects.filter(s => s.code !== subject.code);
      this.availableSubjects.push(subject);
    }
    this.availableSubjects = this.availableSubjects.filter(
      subject => !this.selectedTeacherSubjects.some(s => s.code === subject.code)
    );
  }

  isSubjectAssigned(subject: SubjectDto): boolean {
    return this.selectedTeacherSubjects.some(s => s.code === subject.code);
  }


  saveTeacherSubjects(): void {
    if (this.selectedTeacher !== null && this.selectedTeacherDepartment) {
      const subjectCodes = this.selectedTeacherSubjects.map((s) => s.code);
      this.ts
        .updateTeacherSubjects(this.selectedTeacher.userId, subjectCodes)
        .subscribe(() => {
          this.ns.showSuccess('Údaje úspešne aktualizované');
        });
      this.ts.updateTeacherDepartment(this.selectedTeacher.userId, this.selectedTeacherDepartment.id)
        .subscribe(() => {
        });
      this.closeSubjectModal();
    }
  }

  closeSubjectModal(): void {
    this.showSubjectModal = false;
    this.selectedTeacherId = null;
    this.selectedTeacherSubjects = [];
    this.selectedTeacher = null;
    this.selectedTeacherDepartment = null;
    this.loadAllSubjects();
  }
}
