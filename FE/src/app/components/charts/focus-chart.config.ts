/**
 * Focus chart configuration and utilities
 * Shared between user-form-results and focus-step components
 */

export const FOCUS_LABEL_MAPPING: Record<string, string> = {
  question_matematika_focus: 'Matematika',
  question_logika_focus: 'Logika',
  question_programovanie_focus: 'Programovanie',
  question_dizajn_focus: 'Dizajn',
  question_ekonomika_focus: 'Ekonomika',
  question_manazment_focus: 'Manažment',
  question_hardver_focus: 'Hardvér',
  question_siete_focus: 'Sieťové technológie',
  question_data_focus: 'Práca s dátami',
  question_testovanie_focus: 'Testovanie',
  question_jazyky_focus: 'Jazyky',
  question_fyzicka_aktivita_focus: 'Fyzické zameranie',
};

/**
 * Get focus chart labels in the correct order
 */
export function getFocusChartLabels(): string[] {
  return Object.values(FOCUS_LABEL_MAPPING);
}

/**
 * Get focus chart keys in the correct order
 */
export function getFocusChartKeys(): string[] {
  return Object.keys(FOCUS_LABEL_MAPPING);
}

/**
 * Extract focus data from form data object
 */
export function extractFocusData(formData: Record<string, unknown>): number[] {
  return getFocusChartKeys().map((key) => Number(formData[key]) || 0);
}
