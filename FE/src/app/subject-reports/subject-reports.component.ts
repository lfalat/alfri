import { Component, OnInit } from '@angular/core';
import { SubjectService } from '../services/subject.service';
import { SubjectGradesDto } from '../types';
import { MatTableModule } from '@angular/material/table';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { AsyncPipe, NgForOf, NgIf } from '@angular/common';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { MatAnchor } from '@angular/material/button';


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
  ]
})
export class SubjectReportsComponent implements OnInit {
  subjects: SubjectGradesDto[] = [];
  isLoading = false;
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
    private router: Router) { }

  ngOnInit(): void {
    this.isLoading = true;
    this.dataSource$ = this.subjectsService.getLowestAverageSubjects(10);
    this.isLoading = false;
  }

  public navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }
}
