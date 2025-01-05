import { Component, OnInit } from '@angular/core';
import {
  SubjectPassingPredictionResultComponent
} from '../components/subject-passing-prediction-result/subject-passing-prediction-result.component';
import { SubjectPassingPrediction } from '../types';
import { NgForOf } from '@angular/common';
import { SubjectService } from '../services/subject.service';
import { take } from 'rxjs';
import { MatProgressSpinner } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-passing-prediction',
  standalone: true,
  imports: [SubjectPassingPredictionResultComponent, NgForOf, MatProgressSpinner],
  templateUrl: './passing-prediction.component.html',
  styleUrls: ['./passing-prediction.component.scss'],
})
export class PassingPredictionComponent implements OnInit {
  subjects: SubjectPassingPrediction[] = [];
  isLoading: boolean = true;

  constructor(private subjectService: SubjectService) {
  }

  ngOnInit(): void {
    this.subjectService.makeSubjectsPassingAndMarkPredictions().pipe(take(1)).subscribe((predictionResult: SubjectPassingPrediction[]) => {
      this.isLoading = false;
      console.log(predictionResult);
      this.subjects = predictionResult;

      this.subjects.forEach((subject) => {
        subject.recommendations = this.generateRecommendations(subject.passingProbability);
      });
    });
  }

  generateRecommendations(percentage: number): string[] {
    if (percentage > 90) {
      return [
        'Nepoľavuj! Si na skvelej ceste, pokračuj v dôslednej príprave tak, ako doteraz.',
        'Pomôž svojim spolužiakom s náročnými témami alebo zadaniami – upevníš si tým svoje znalosti.',
        'Vidno, že ťa predmet zaujíma. Zváž zisk vedomostí nad rámec osnovy predmetu.',
      ];
    } else if (percentage >= 80) {
      return [
        'Zapoj sa do diskusií so svojimi spolužiakmi, navzájom si dokážete pomôcť.',
        'Zostaň sebavedomý! Dôkladne as priprav na priebežné testy, zadania a skúšku.',
        'Pokračuj v dodržiavaní svojich aktuálnych učebných návykov, ide ti to dobre!',
      ];
    } else if (percentage >= 50) {
      return [
        'Pravidelne si prezeraj materiály a zameraj sa na oblasti, ktoré ti pripadajú zložité.',
        'Zváž vytvorenie študijnej skupiny so svojimi spolužiakmi a opýtaj sa ich, keď si nebudeš niečím istý',
        'Nezanedbávaj prednášky a cvičenia. Precvič si úlohy z cvičení aj doma.',
      ];
    } else {
      return [
        'Vyhľadaj pomoc učiteľa alebo spolužiakov pri náročných úlohách a témach.',
        'Venuj viac hodín štúdiu predmetu, a nezabúdaj sa pravidelne zúčastňovať prednášok a cvičení.',
        'Rozdeľ si učivo na zvládnuteľné časti, ktoré budeš schopný systematicky prechádzať.',
      ];
    }
  }
}
