#!/usr/bin/env python3
"""
Script to convert keywords.sql from using subject codes to subject IDs.
Also adds occurrence count columns.
"""

import re
import os

# Build mapping from subject codes to IDs
code_to_id = {}

# Read from subjects.sql
print("Reading subjects.sql to build code->ID mapping...")
subjects_file = 'src/main/resources/db/data/subjects.sql'
if os.path.exists(subjects_file):
    with open(subjects_file, 'r', encoding='utf-8') as f:
        for line in f:
            # Extract: INSERT INTO public.subject (subject_id, name, code, abbreviation) VALUES (1, 'algebra', '6BA0001', 'Alg');
            match = re.search(r"INSERT INTO public\.subject \(subject_id, name, code, abbreviation\) VALUES \((\d+),\s*'[^']*',\s*'([^']+)'", line)
            if match:
                subject_id = int(match.group(1))
                code = match.group(2)
                code_to_id[code] = subject_id
    print(f"Found {len(code_to_id)} subject code->ID mappings from subjects.sql")
else:
    print(f"ERROR: {subjects_file} not found!")
    exit(1)

# Read and convert keywords.sql
keywords_file = 'src/main/resources/db/data/keywords.sql'
output_lines = []
missing_codes = set()
converted_count = 0
skipped_count = 0

print("\nConverting keywords.sql...")
with open(keywords_file, 'r', encoding='utf-8') as f:
    for line_num, line in enumerate(f, 1):
        line = line.strip()
        if not line or line.startswith('--'):
            continue

        # Parse: INSERT INTO public.subject_keyword (keyword, subject_code1, subject_code2, subject_code3) VALUES ('dát', '6UI0002', '6BI0005', '6BA0003');
        # Also handle null without quotes
        match = re.search(r"INSERT INTO public\.subject_keyword \(keyword, subject_code1, subject_code2, subject_code3\) VALUES \('([^']+)',\s*(?:'([^']+)'|null),\s*(?:'([^']+)'|null),\s*(?:'([^']+)'|null)\);?", line)

        if match:
            keyword = match.group(1)
            code1 = match.group(2) if match.group(2) and match.group(2) != 'null' else None
            code2 = match.group(3) if match.group(3) and match.group(3) != 'null' else None
            code3 = match.group(4) if match.group(4) and match.group(4) != 'null' else None

            # Convert codes to IDs
            id1 = code_to_id.get(code1) if code1 else None
            id2 = code_to_id.get(code2) if code2 else None
            id3 = code_to_id.get(code3) if code3 else None

            # Track missing codes
            if code1 and not id1:
                missing_codes.add(code1)
            if code2 and not id2:
                missing_codes.add(code2)
            if code3 and not id3:
                missing_codes.add(code3)

            # Skip entries where none of the codes were found
            if code1 and not id1 and code2 and not id2 and code3 and not id3:
                skipped_count += 1
                print(f"  Line {line_num}: SKIPPED '{keyword}' - no valid subject IDs found")
                continue

            # For occurrence counts, use placeholder value of 1
            count1 = 1 if id1 else 0
            count2 = 1 if id2 else 0
            count3 = 1 if id3 else 0

            # Build new INSERT statement
            new_line = f"INSERT INTO public.subject_keyword (keyword, subject_1, subject_1_occurence, subject_2, subject_2_occurence, subject_3, subject_3_occurence) VALUES ('{keyword}', "
            new_line += f"{id1 if id1 else 'null'}, {count1}, "
            new_line += f"{id2 if id2 else 'null'}, {count2}, "
            new_line += f"{id3 if id3 else 'null'}, {count3});"

            output_lines.append(new_line)
            converted_count += 1

print(f"\nConversion complete:")
print(f"  Converted: {converted_count} entries")
print(f"  Skipped: {skipped_count} entries")

if missing_codes:
    print(f"\nWARNING: {len(missing_codes)} subject codes were not found in subjects.sql:")
    for code in sorted(missing_codes)[:20]:  # Show first 20
        print(f"  - {code}")
    if len(missing_codes) > 20:
        print(f"  ... and {len(missing_codes) - 20} more")

# Write new file
with open(keywords_file, 'w', encoding='utf-8') as f:
    for line in output_lines:
        f.write(line + '\n')

print(f"\nWrote updated keywords.sql with {len(output_lines)} entries")
print("Done!")

