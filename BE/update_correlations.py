#!/usr/bin/env python3
"""
Script to subtract 88 from first_subject and second_subject fields in correlations.sql
"""

import re

def process_correlation_file(input_file, output_file):
    """
    Read the correlations.sql file and subtract 88 from first_subject and second_subject values.

    Args:
        input_file: Path to the input SQL file
        output_file: Path to the output SQL file
    """
    with open(input_file, 'r') as f:
        content = f.read()

    # Pattern to match INSERT statements with first_subject, second_subject, and correlation
    pattern = r'INSERT INTO public\.subject_grade_correlation \(first_subject, second_subject, correlation\)\s*VALUES \((\d+), (\d+), ([^)]+)\);'

    def replace_values(match):
        first_subject = int(match.group(1))
        second_subject = int(match.group(2))
        correlation = match.group(3)

        # Subtract 88 from both subject values
        new_first = first_subject - 88
        new_second = second_subject - 88

        return f'INSERT INTO public.subject_grade_correlation (first_subject, second_subject, correlation)\nVALUES ({new_first}, {new_second}, {correlation});'

    # Replace all occurrences
    updated_content = re.sub(pattern, replace_values, content)

    # Write to output file
    with open(output_file, 'w') as f:
        f.write(updated_content)

    print(f"Successfully processed {input_file}")
    print(f"Updated data written to {output_file}")

if __name__ == "__main__":
    input_file = "correlations.sql"
    output_file = "correlations.sql"  # Will overwrite the original file

    process_correlation_file(input_file, output_file)
    print("Done! All first_subject and second_subject values have been decreased by 88.")

