import { Component, OnInit } from '@angular/core';
import { ErrorService } from '../services/error.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent implements OnInit {

  constructor(private errorService: ErrorService) {
  }

  ngOnInit(): void {
    this.errorService.showError('Registrácia prebehla úspešne.');
  }
}
