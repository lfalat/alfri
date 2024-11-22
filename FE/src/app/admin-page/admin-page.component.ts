import { Component, OnInit } from '@angular/core';
import { AdminService } from '../services/admin.service';
import { UserService } from '../services/user.service';
import { Role, SubjectDto, UserDto } from '../types';
import { NgForOf, NgIf } from '@angular/common';

@Component({
  selector: 'app-admin',
  templateUrl: './admin-page.component.html',
  styleUrls: ['./admin-page.component.scss'],
  imports: [
    NgForOf,
    NgIf
  ],
  standalone: true
})
export class AdminPageComponent implements OnInit {
  users: UserDto[] = [
    {
      userId: 1,
      firstName: 'John',
      lastName: 'Doe',
      roles: [
        { id: 1, name: 'student' },
        { id: 4, name: 'admin' },
      ],
      email: 'john.doe@example.com',
    },
    {
      userId: 2,
      firstName: 'Jane',
      lastName: 'Smith',
      roles: [{ id: 2, name: 'teacher' }],
      email: 'jane.smith@example.com',
    },
    {
      userId: 3,
      firstName: 'Alice',
      lastName: 'Johnson',
      roles: [{ id: 3, name: 'visitor' }],
      email: 'alice.johnson@example.com',
    },
    {
      userId: 4,
      firstName: 'Bob',
      lastName: 'Brown',
      roles: [
        { id: 1, name: 'student' },
        { id: 3, name: 'visitor' },
      ],
      email: 'bob.brown@example.com',
    },
    {
      userId: 5,
      firstName: 'Emma',
      lastName: 'Wilson',
      roles: [
        { id: 2, name: 'teacher' },
        { id: 3, name: 'visitor' },
      ],
      email: 'emma.wilson@example.com',
    },
  ];
  availableRoles: Role[] = [
    { id: 1, name: 'teacher' },
    { id: 2, name: 'student' },
    { id: 3, name: 'visitor' },
    { id: 4, name: 'admin' },
  ];

  allSubjects: SubjectDto[] = [
    {
      name: 'Introduction to Computer Science',
      code: 'CS101',
      abbreviation: 'CS',
      studyProgramName: 'Computer Science',
      recommendedYear: 1,
      semester: 'Fall',
    },
    {
      name: 'Linear Algebra',
      code: 'MATH201',
      abbreviation: 'LA',
      studyProgramName: 'Mathematics',
      recommendedYear: 1,
      semester: 'Spring',
    },
    {
      name: 'Data Structures and Algorithms',
      code: 'CS202',
      abbreviation: 'DSA',
      studyProgramName: 'Computer Science',
      recommendedYear: 2,
      semester: 'Fall',
    },
    {
      name: 'Organic Chemistry',
      code: 'CHEM301',
      abbreviation: 'OC',
      studyProgramName: 'Chemistry',
      recommendedYear: 2,
      semester: 'Spring',
    },
    {
      name: 'Quantum Physics',
      code: 'PHYS401',
      abbreviation: 'QP',
      studyProgramName: 'Physics',
      recommendedYear: 3,
      semester: 'Fall',
    },
  ];

  availableSubjects: SubjectDto[] = [
    {
      name: 'Introduction to Computer Science',
      code: 'CS101',
      abbreviation: 'CS',
      studyProgramName: 'Computer Science',
      recommendedYear: 1,
      semester: 'Fall',
    },
    {
      name: 'Linear Algebra',
      code: 'MATH201',
      abbreviation: 'LA',
      studyProgramName: 'Mathematics',
      recommendedYear: 1,
      semester: 'Spring',
    },
    {
      name: 'Data Structures and Algorithms',
      code: 'CS202',
      abbreviation: 'DSA',
      studyProgramName: 'Computer Science',
      recommendedYear: 2,
      semester: 'Fall',
    },
    {
      name: 'Organic Chemistry',
      code: 'CHEM301',
      abbreviation: 'OC',
      studyProgramName: 'Chemistry',
      recommendedYear: 2,
      semester: 'Spring',
    },
    {
      name: 'Quantum Physics',
      code: 'PHYS401',
      abbreviation: 'QP',
      studyProgramName: 'Physics',
      recommendedYear: 3,
      semester: 'Fall',
    },
  ];

  showSubjectModal = false;
  selectedUser: UserDto | undefined = undefined;
  selectedTeacherId: number | null = null;
  selectedTeacherSubjects: SubjectDto[] = [];
  mockSubjects: SubjectDto[] = [{
    name: 'Introduction to Computer Science',
    code: 'CS101',
    abbreviation: 'CS',
    studyProgramName: 'Computer Science',
    recommendedYear: 1,
    semester: 'Fall',
  },
    {
      name: 'Linear Algebra',
      code: 'MATH201',
      abbreviation: 'LA',
      studyProgramName: 'Mathematics',
      recommendedYear: 1,
      semester: 'Spring',
    }];

  constructor(private as: AdminService, private us: UserService) {
  }

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
    this.loadAllSubjects();
  }

  userHasRole(user: UserDto, role: Role): boolean {
    return user.roles.some((userRole: Role) => userRole.id === role.id);
  }

  onRoleToggle(user: any, role: Role, event: Event): void {
    const isAdd = (event.target as HTMLInputElement).checked;

    this.as.updateUserRole(user.id, role, isAdd).subscribe(() => {
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
    // this.availableSubjects = this.allSubjects;
    this.as.getAllSubjects().subscribe((subjects) => {
      this.availableSubjects = subjects;
    });
  }

  // openSubjectModal(teacherId: number): void {
  //   this.selectedTeacherId = teacherId;
  //
  //   // this.as.getTeacherSubjects(teacherId).subscribe((subjects) => {
  //   //   this.teacherSubjects = subjects;
  //   //   this.showSubjectModal = true;
  //   // });
  //
  //   // this.selectedTeacherSubjects = this.availableSubjects; // just to showcase
  //   this.showSubjectModal = true;
  // }

  openSubjectModal(userId: number): void {
    this.selectedUser = this.users.find(user => user.userId === userId && this.userHasRole(user, {
      id: 2,
      name: 'teacher'
    }));

    if (this.selectedUser) {
      this.as.getTeacherSubjects(userId).subscribe((subjects) => {
        this.selectedTeacherSubjects = subjects;
        this.showSubjectModal = true;
      });
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
    if (this.selectedTeacherId !== null) {
      const subjectCodes = this.selectedTeacherSubjects.map((s) => s.code); // Collect subject codes
      this.as
        .updateTeacherSubjects(this.selectedTeacherId, subjectCodes)
        .subscribe(() => {
          alert('Subjects updated successfully!'); //TODO pre upozornenia pouzivaj NotificationService, vyzera to lepsie :D
          this.closeSubjectModal();
        });
    }
  }

  closeSubjectModal(): void {
    this.showSubjectModal = false;
    this.selectedTeacherId = null;
    this.selectedTeacherSubjects = [];
    this.loadAllSubjects();
  }
}
