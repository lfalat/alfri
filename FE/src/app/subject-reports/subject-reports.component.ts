import { Component, OnInit } from '@angular/core';
import { SubjectService } from '../services/subject.service';
import { SubjectGradesDto } from '../types';
import { MatTableModule } from '@angular/material/table';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { AsyncPipe, NgForOf, NgIf } from '@angular/common';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { MatAnchor } from '@angular/material/button';
import { MatRadioButton, MatRadioGroup } from '@angular/material/radio';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-subject-reports',
  templateUrl: './subject-reports.component.html',
  standalone: true,
  styleUrls: ['./subject-reports.component.scss'],
  imports: [
    MatTableModule,
    MatProgressBarModule,
    AsyncPipe,
    NgIf,
    NgForOf,
    MatAnchor,
    MatRadioButton,
    MatRadioGroup,
    FormsModule,
  ]
})
export class SubjectReportsComponent implements OnInit {
  subjects: SubjectGradesDto[] = [];
  isLoading = false;

  subjectCount = 10;
  sortCriteria = 'lowestAverage';

  public readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'studentsCount',
    'gradeA',
    'gradeB',
    'gradeC',
    'gradeD',
    'gradeE',
    'gradeFx',
    'averageScore'
  ];

  dataSource$!: Observable<SubjectGradesDto[]>;

  constructor(
    private subjectsService: SubjectService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.fetchFilteredSubjects();
  }

  // Fetch data and apply filters based on user selections
  fetchFilteredSubjects(): void {
    this.isLoading = true;

    // Fetch filtered subjects based on sort and limit criteria
    this.dataSource$ = this.subjectsService.getFilteredSubjects(this.sortCriteria, this.subjectCount);

    this.isLoading = false;
  }

  // Navigate to subject detail page
  public navigateToSubjectDetail(code: string): void {
    this.router.navigate(['/subjects/' + code]);
  }

  // Called when user changes the number of subjects or sorting criteria
  onUserSelectionChange(): void {
    this.fetchFilteredSubjects();
  }
}
