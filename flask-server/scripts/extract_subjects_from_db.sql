-- SQL Query to extract subject data with focus vectors for clustering
-- Run this against your Spring Boot PostgreSQL database
-- This will give you the 87 subjects that were used to train the KMeans model

-- For INF program (studyProgramId = 3), assuming subjects 1-87
SELECT
    s.subject_id,
    s.name,
    s.code,
    s.abbreviation,
    f.math_focus,
    f.logic_focus,
    f.programming_focus,
    f.design_focus,
    f.economics_focus,
    f.management_focus,
    f.hardware_focus,
    f.network_focus,
    f.data_focus,
    f.testing_focus,
    f.language_focus,
    f.physical_focus,
    -- Create focus vector as JSON array for easy import
    json_build_array(
        f.math_focus,
        f.logic_focus,
        f.programming_focus,
        f.design_focus,
        f.economics_focus,
        f.management_focus,
        f.hardware_focus,
        f.network_focus,
        f.data_focus,
        f.testing_focus,
        f.language_focus,
        f.physical_focus
    ) as focus_vector
FROM subject s
INNER JOIN focus f ON s.subject_id = f.subject_id
INNER JOIN study_program_subject sps ON s.subject_id = sps.subject_id
WHERE sps.study_program_id = 3  -- INF program
ORDER BY s.subject_id
LIMIT 87;

-- For Management program (studyProgramId = 4), you'd use:
-- WHERE sps.study_program_id = 4

-- To export to JSON file directly in psql:
-- \copy (SELECT json_agg(row_to_json(t)) FROM (... above query ...) t) TO '/tmp/subjects_inf.json'

