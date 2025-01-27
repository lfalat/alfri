import { Component, OnInit } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatChipsModule } from '@angular/material/chips';
import { Router } from '@angular/router';
import { NgForOf, NgIf } from '@angular/common';
import { MatFormField, MatLabel } from '@angular/material/form-field';
import { KeywordService } from '@services/keyword.service';
import { debounceTime, distinctUntilChanged, Subject } from 'rxjs';
import { MatInput } from '@angular/material/input';
import { SubjectExtendedDto } from '../../types';

@Component({
  selector: 'app-keywords',
  templateUrl: './keywords.component.html',
  standalone: true,
  styleUrls: ['./keywords.component.scss'],
  imports: [
    MatTableModule,
    MatChipsModule,
    NgForOf,
    NgIf,
    MatFormField,
    MatInput,
    MatLabel,
  ],
})
export class KeywordsComponent implements OnInit {
  filteredKeywords: string[] = [];
  keywords: string[] = [];
  selectedKeywords: string[] = [];
  keywordSubjects: { [key: string]: SubjectExtendedDto[] } = {};

  readonly columnsToDisplay: string[] = [
    'name',
    'code',
    'abbreviation',
    'studyProgramName',
    'recommendedYear',
    'semester',
  ];
  searchSubject = new Subject<string>();

  constructor(
    private router: Router,
    private keywordService: KeywordService,
  ) {}

  ngOnInit(): void {
    this.searchSubject
      .pipe(debounceTime(300), distinctUntilChanged())
      .subscribe((searchText) => {
        this.fetchKeywords(searchText);
      });
  }

  onSearch(event: any): void {
    const searchText = event.target.value;
    this.searchSubject.next(searchText);
  }

  fetchKeywords(searchText: string): void {
    if (!searchText.trim()) {
      this.filteredKeywords = [];
      return;
    }

    this.keywordService.searchKeywords(searchText).subscribe((results) => {
      this.filteredKeywords = results;
      if (!results.length) {
        this.filteredKeywords = [];
      }
    });
  }

  onKeywordSelect(keyword: string): void {
    if (!this.selectedKeywords.includes(keyword)) {
      this.selectedKeywords.push(keyword);
      this.keywordService.showSubjects(keyword).subscribe((subjects) => {
        this.keywordSubjects[keyword] = subjects;
      });
    } else {
      this.selectedKeywords = this.selectedKeywords.filter(
        (item) => item !== keyword,
      );
      delete this.keywordSubjects[keyword];
    }
  }

  public navigateToSubjectDetail(code: string): void {
    this.router.navigate(['/subjects/' + code]);
  }
}
