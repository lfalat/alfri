import { Component, OnInit } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatChipsModule } from '@angular/material/chips';
import { KeywordDto, SubjectDto } from '../types';
import { Observable } from 'rxjs';
import { SubjectService } from '../services/subject.service';
import { Router } from '@angular/router';
import { NgForOf, NgIf } from '@angular/common';


interface Subject {
  code: string;
  name: string;
}

@Component({
  selector: 'app-keywords',
  templateUrl: './keywords.component.html',
  standalone: true,
  styleUrls: ['./keywords.component.scss'],
  imports: [
    MatTableModule,
    MatChipsModule,
    NgForOf,
    NgIf
  ]
})
export class KeywordsComponent implements OnInit {

  keywords: KeywordDto[] = [];
  selectedKeywords: KeywordDto[] = [];

  public readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'abbreviation',
    'studyProgramName',
    'recommendedYear',
    'semester'
  ];
  dataSource$!: Observable<KeywordDto[]>;
  constructor(
    private subjectsService: SubjectService,
    private router: Router) { }

  ngOnInit(): void {
    // this.dataSource$ = this.subjectsService.getKeywords();
    this.loadKeywords();
  }
  loadKeywords(): void {
    //TODO: replace with DB data
    const mockSubject: SubjectDto = {
      name: 'Mathematics',
      code: 'MATH101',
      abbreviation: 'MATH',
      studyProgramName: 'Computer Science',
      recommendedYear: 1,
      semester: 'Fall'
    };
    this.keywords = [
      { keyword: 'Keyword 1', subjects: [mockSubject, mockSubject, mockSubject] },
      { keyword: 'Keyword 2', subjects: [mockSubject, mockSubject] },
      { keyword: 'Keyword 3', subjects: [mockSubject] }
    ];
  }

  // Triggered when a chip is clicked
  onKeywordSelect(keyword: KeywordDto): void {
    if (this.selectedKeywords.includes(keyword)) {
      this.selectedKeywords = this.selectedKeywords.filter(k => k !== keyword);
    } else {
      this.selectedKeywords.push(keyword);
    }
  }

  // Get subjects for a given keyword
  getSubjectsForKeyword(keyword: KeywordDto): Subject[] {
    return keyword.subjects;
  }

  public navigateToSubjectDetail(code: string) {
    this.router.navigate(['/subjects/' + code]);
  }

}
