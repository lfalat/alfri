import { Component, Input } from '@angular/core';
import { NgStyle } from '@angular/common';

type HorizontalAlignments = 'bottom' | 'top' | 'left' | 'right';

type VerticalAlignments = 'bottom' | 'top'| 'left' | 'right' | 'center';


@Component({
  selector: 'app-speech-bubble',
  standalone: true,
  imports: [
    NgStyle
  ],
  templateUrl: './speech-bubble.component.html',
  styleUrl: './speech-bubble.component.scss'
})
export class SpeechBubbleComponent {
  @Input() horizontalAllign: HorizontalAlignments = 'bottom';
  @Input() verticalAllign: VerticalAlignments = 'right';
  @Input() color = '#af2d58';
  @Input() text = '';
  @Input() textColor = '#FFF';

  get bubbleStyles() {
    return { '--bbColor': this.color, color: this.textColor };
  }
}
