import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'gradeClass',
  standalone: true,
  pure: true,
})
export class GradeClassPipe implements PipeTransform {
  transform(grade: string): string {
    const gradeUpper = grade.toUpperCase();
    if (gradeUpper === 'A') return 'grade-a';
    if (gradeUpper === 'B') return 'grade-b';
    if (gradeUpper === 'C') return 'grade-c';
    if (gradeUpper === 'D') return 'grade-d';
    if (gradeUpper === 'E') return 'grade-e';
    if (gradeUpper === 'FX') return 'grade-fx';
    return 'grade-default';
  }
}
