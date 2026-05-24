/**
 * Utility class for grade-related operations
 */
export class GradeUtils {
  /**
   * Converts letter grade (A-Fx) to numeric value
   * @param letterGrade - The letter grade to convert (A, B, C, D, E, Fx)
   * @returns Numeric value of the grade, 0 for invalid
   */
  static letterGradeToNumber(letterGrade: string): number {
    const gradeMap: Record<string, number> = {
      A: 1.0,
      B: 1.5,
      C: 2.0,
      D: 2.5,
      E: 3.0,
      Fx: 4.0,
    };

    const normalizedGrade = letterGrade.trim().toUpperCase();
    return gradeMap[normalizedGrade] ?? 0;
  }

  /**
   * Calculates the average of numeric grades
   * @param grades - Array of numeric grades
   * @returns Average grade formatted to 2 decimal places, or '0.00' if no valid grades
   */
  static calculateAverage(grades: number[]): string {
    const validGrades = grades.filter((grade) => grade > 0);

    if (validGrades.length === 0) {
      return '0.00';
    }

    const average = validGrades.reduce((sum, grade) => sum + grade, 0) / validGrades.length;
    return average.toFixed(2);
  }
}
