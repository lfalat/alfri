import { Component, inject, OnInit, signal } from '@angular/core';
import { MatTableModule } from '@angular/material/table';
import { MatChipsModule } from '@angular/material/chips';
import { Router } from '@angular/router';

import { MatFormField, MatLabel } from '@angular/material/form-field';
import { KeywordService } from '@services/keyword.service';
import { debounceTime, distinctUntilChanged, Subject } from 'rxjs';
import { MatInput } from '@angular/material/input';
import { SubjectExtendedDto } from '../../types';
import {
  MatCard,
  MatCardContent,
  MatCardHeader,
  MatCardSubtitle,
  MatCardTitle,
} from '@angular/material/card';
import { MatOption } from '@angular/material/select';
import { MatAutocomplete, MatAutocompleteTrigger } from '@angular/material/autocomplete';
import { MatIcon } from '@angular/material/icon';

@Component({
  selector: 'app-keywords',
  templateUrl: './keywords.component.html',
  standalone: true,
  styleUrls: ['./keywords.component.scss'],
  imports: [
    MatTableModule,
    MatChipsModule,
    MatFormField,
    MatInput,
    MatLabel,
    MatCard,
    MatCardHeader,
    MatCardTitle,
    MatCardSubtitle,
    MatCardContent,
    MatOption,
    MatAutocompleteTrigger,
    MatAutocomplete,
    MatIcon,
  ],
})
export class KeywordsComponent implements OnInit {
  filteredKeywords = signal<string[]>([]);
  keywords: string[] = [];
  selectedKeywords = signal<string[]>([]);
  keywordSubjects = signal<{ [key: string]: SubjectExtendedDto[] }>({});

  readonly columnsToDisplay: string[] = ['name', 'code', 'abbreviation'];
  searchSubject = new Subject<string>();
  isError = false;

  private readonly router = inject(Router);
  private readonly keywordService = inject(KeywordService);

  ngOnInit(): void {
    this.handleRedirect();

    this.searchSubject.pipe(debounceTime(300), distinctUntilChanged()).subscribe((searchText) => {
      this.fetchKeywords(searchText);
    });
  }

  onSearch(event: Event): void {
    const target = event.target as HTMLInputElement;

    if (target) {
      const searchText = target.value;
      this.searchSubject.next(searchText);
    }
  }

  fetchKeywords(searchText: string): void {
    if (!searchText.trim()) {
      this.filteredKeywords.set([]);
      return;
    }

    this.keywordService.searchKeywords(searchText).subscribe({
      next: (results) => {
        this.filteredKeywords.set(results);
        if (!results.length) {
          this.filteredKeywords.set([]);
        }
        this.isError = false;
      },
      error: () => {
        this.filteredKeywords.set([]);
        this.isError = true;
      },
    });
  }

  onKeywordSelect(keyword: string, inputElement: HTMLInputElement): void {
    if (!this.selectedKeywords().includes(keyword)) {
      this.selectedKeywords.update(value => [...value, keyword]); // Add keyword if not already selected
      this.keywordService.showSubjects(keyword).subscribe((subjects) => {
        this.keywordSubjects.update((value) => ({
          ...value,
          [keyword]: subjects,
        }));
      });
    }
    inputElement.value = ''; // Clear the input field
    this.filteredKeywords.set([]); // Clear the filtered keywords
  }

  onKeywordRemove(keyword: string): void {
    this.selectedKeywords.update((value) => value.filter((item) => item !== keyword));
    this.keywordSubjects.update((value) => {
      const { [keyword]: _, ...rest } = value;
      return rest;
    });
  }

  public navigateToSubjectDetail(code: string): void {
    this.router.navigate(['/subjects/' + code]);
  }

  displayKeyword(keyword: string): string {
    return keyword || '';
  }

  /**
   * Handles the redirect to the keywords component from a keyword click
   */
  private handleRedirect() {
    const keyword = history.state.word;
    if (!keyword) {
      return;
    }

    this.selectedKeywords.update((value) => [...value, keyword]);
    this.keywordService.showSubjects(keyword).subscribe((subjects) => {
      this.keywordSubjects.update((value) => ({
        ...value,
        [keyword]: subjects,
      }));
    });
  }
}
