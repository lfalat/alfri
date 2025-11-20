# Clustering-Based Subject Recommendation System

## Overview

This module provides intelligent subject recommendations based on KMeans clustering of 12-dimensional focus vectors.

## Focus Dimensions

Each subject has 12 focus attributes (0-10 scale):

| Index | Dimension | Description |
|-------|-----------|-------------|
| 0 | `mathFocus` | Mathematical foundations and theory |
| 1 | `logicFocus` | Logical thinking and reasoning |
| 2 | `programmingFocus` | Programming and coding skills |
| 3 | `designFocus` | System and software design |
| 4 | `economicsFocus` | Economics and business knowledge |
| 5 | `managementFocus` | Project and team management |
| 6 | `hardwareFocus` | Hardware and computer architecture |
| 7 | `networkFocus` | Networking and distributed systems |
| 8 | `dataFocus` | Data structures and databases |
| 9 | `testingFocus` | Testing and quality assurance |
| 10 | `languageFocus` | Foreign language skills |
| 11 | `physicalFocus` | Physical education and sports |

## Setup

### 1. Generate Subjects Metadata

You need to create a subjects metadata JSON file that maps each subject to its cluster label.

#### Option A: From Database (Recommended)

```bash
# Install psycopg2 if not already installed
pip install psycopg2-binary

# Generate metadata for INF program (study_program_id = 3)
python3 scripts/generate_subjects_metadata.py \
  --db "postgresql://user:password@localhost:5432/alfri" \
  --study-program 3

# Generate metadata for Management program (study_program_id = 4)
python3 scripts/generate_subjects_metadata.py \
  --db "postgresql://user:password@localhost:5432/alfri" \
  --study-program 4
```

This will create:
- `ml_service/models/subjects_metadata_inf.json`
- `ml_service/models/subjects_metadata_management.json`

#### Option B: From Exported JSON

First, export subjects from your database:

```bash
# In psql
\copy (
  SELECT 
    s.subject_id as id,
    s.name,
    s.code,
    s.abbreviation,
    json_build_array(
      f.math_focus, f.logic_focus, f.programming_focus, f.design_focus,
      f.economics_focus, f.management_focus, f.hardware_focus, f.network_focus,
      f.data_focus, f.testing_focus, f.language_focus, f.physical_focus
    ) as focus_vector
  FROM subject s
  INNER JOIN focus f ON s.subject_id = f.subject_id
  INNER JOIN study_program_subject sps ON s.subject_id = sps.subject_id
  WHERE sps.study_program_id = 3
  ORDER BY s.subject_id
) TO '/tmp/subjects_inf.json'
```

Then generate metadata:

```bash
python3 scripts/generate_subjects_metadata.py \
  --input /tmp/subjects_inf.json \
  --study-program 3
```

### 2. Verify Setup

```bash
# Check clustering stats
curl -H "X-API-Key: your-key" \
  http://localhost:5000/api/v1/clustering/stats/3

# List all subjects with clusters
curl -H "X-API-Key: your-key" \
  http://localhost:5000/api/v1/clustering/subjects/3
```

## API Endpoints

### 1. Get Recommendations

**POST** `/api/v1/clustering/recommend`

Get similar subject recommendations based on selected subjects.

**Request:**
```json
{
  "subjectIds": [1, 5, 12],
  "studyProgramId": 3,
  "maxRecommendations": 10,
  "method": "cluster"
}
```

**Parameters:**
- `subjectIds` (required): Array of selected subject IDs (1-3 subjects recommended)
- `studyProgramId` (required): Study program ID (3 = INF, 4 = Management)
- `maxRecommendations` (optional): Max number of recommendations (default: 10)
- `method` (optional): Recommendation method:
  - `"cluster"` (default): Only recommend subjects from same cluster(s)
  - `"distance"`: Recommend closest subjects regardless of cluster

**Response:**
```json
{
  "studyProgramId": 3,
  "method": "cluster",
  "selectedSubjects": [
    {
      "id": 1,
      "name": "Algorithms and Data Structures",
      "code": "INF001",
      "cluster_label": 2
    }
  ],
  "centroid": [8.0, 9.0, 7.0, 1.0, 0.0, 0.0, 0.0, 0.0, 6.0, 0.0, 0.0, 0.0],
  "selectedClusters": [2],
  "recommendations": [
    {
      "id": 2,
      "name": "Database Systems",
      "code": "INF002",
      "abbreviation": "DBS",
      "cluster_label": 2,
      "similarity_score": 0.8523,
      "distance": 2.34
    },
    ...
  ]
}
```

**Similarity Score:** Range 0-1, higher is better. Calculated as `1 / (1 + euclidean_distance)`.

### 2. List Subjects

**GET** `/api/v1/clustering/subjects/{studyProgramId}`

Get all subjects with their cluster assignments.

**Query Parameters:**
- `cluster` (optional): Filter by cluster label (e.g., `?cluster=2`)

**Response:**
```json
{
  "studyProgramId": 3,
  "nSubjects": 87,
  "nClusters": 6,
  "focusDimensions": ["mathFocus", "logicFocus", ...],
  "subjects": [
    {
      "id": 1,
      "name": "Algorithms and Data Structures",
      "code": "INF001",
      "abbreviation": "ADS",
      "cluster_label": 2,
      "study_program_id": 3,
      "focus_vector": [8, 9, 7, 1, 0, 0, 0, 0, 6, 0, 0, 0]
    },
    ...
  ]
}
```

### 3. Get Statistics

**GET** `/api/v1/clustering/stats/{studyProgramId}`

Get clustering statistics for a study program.

**Response:**
```json
{
  "studyProgramId": 3,
  "nSubjects": 87,
  "nClusters": 6,
  "clusterDistribution": {
    "0": 8,
    "1": 22,
    "2": 17,
    "3": 8,
    "4": 11,
    "5": 21
  },
  "focusDimensions": ["mathFocus", "logicFocus", ...]
}
```

## Clustering Model

### Model Details
- **Algorithm:** KMeans
- **Clusters:** 6
- **Training data:** 87 subjects (INF program)
- **Model file:** `ml_service/models/kmeans_model.pkl`

### Cluster Characteristics

| Cluster | Subjects | Specialization |
|---------|----------|----------------|
| 0 | 8 (9%) | Highly specialized - Physical education (focus on dimension 11) |
| 1 | 22 (25%) | Multidisciplinary - Logic, Programming, Design (dimensions 1-3) |
| 2 | 17 (20%) | Math & Data focused - Strong Math, Logic, Data skills (0, 1, 8) |
| 3 | 8 (9%) | Language & Management - Foreign languages, Management (5, 10) |
| 4 | 11 (13%) | Business oriented - Economics, Management (4, 5) |
| 5 | 21 (24%) | Technical - Logic, Programming, Networks, Hardware (1, 2, 6, 7) |

## Usage Examples

### Example 1: Get recommendations for selected subjects

```python
import requests

response = requests.post(
    "http://localhost:5000/api/v1/clustering/recommend",
    headers={"X-API-Key": "your-key"},
    json={
        "subjectIds": [1, 2, 7],  # Selected: ADS, DBS, Intro Programming
        "studyProgramId": 3,
        "maxRecommendations": 5
    }
)

recommendations = response.json()["recommendations"]
for rec in recommendations:
    print(f"{rec['name']} (similarity: {rec['similarity_score']})")
```

### Example 2: Find all subjects in a specific cluster

```python
response = requests.get(
    "http://localhost:5000/api/v1/clustering/subjects/3?cluster=2",
    headers={"X-API-Key": "your-key"}
)

subjects = response.json()["subjects"]
print(f"Cluster 2 has {len(subjects)} subjects:")
for subj in subjects:
    print(f"  - {subj['name']}")
```

### Example 3: Analyze cluster distribution

```python
response = requests.get(
    "http://localhost:5000/api/v1/clustering/stats/3",
    headers={"X-API-Key": "your-key"}
)

stats = response.json()
for cluster, count in stats["clusterDistribution"].items():
    pct = (count / stats["nSubjects"]) * 100
    print(f"Cluster {cluster}: {count} subjects ({pct:.1f}%)")
```

## Testing

Run tests:

```bash
# Test new clustering endpoints
pytest tests/test_clustering_v2.py -v

# Run all tests
pytest tests/ -v
```

## Migration from Old Endpoint

### Old Endpoint (Broken)
```
POST /api/v1/clustering/similar-subjects
{
  "focusVectors": [[...], [...]],
  "studyProgramId": 3
}
→ Returns: {"cluster_indices": [2, 5, 2]}  ❌ Not useful!
```

### New Endpoint (Correct)
```
POST /api/v1/clustering/recommend
{
  "subjectIds": [1, 5, 12],
  "studyProgramId": 3
}
→ Returns: {"recommendations": [{id, name, similarity_score}, ...]}  ✅ Useful!
```

## Troubleshooting

### Error: "Subjects metadata not found"

Generate the metadata file:
```bash
python3 scripts/generate_subjects_metadata.py \
  --db "postgresql://user:pass@localhost:5432/alfri" \
  --study-program 3
```

### Error: "Subject ID X not found"

The subject might not be in the training data (87 subjects). Check available subjects:
```bash
curl -H "X-API-Key: your-key" \
  http://localhost:5000/api/v1/clustering/subjects/3
```

### Need to retrain the model?

If you add/modify subjects, you need to:
1. Retrain the KMeans model with new data
2. Regenerate the subjects metadata file
3. Update the cluster labels

## Files

- `ml_service/blueprints/clustering_v2.py` - New implementation
- `ml_service/blueprints/clustering.py` - Old implementation (legacy)
- `ml_service/models/kmeans_model.pkl` - Pre-trained KMeans model
- `ml_service/models/subjects_metadata_inf.json` - INF program subjects (generated)
- `ml_service/models/subjects_metadata_management.json` - Management subjects (generated)
- `scripts/generate_subjects_metadata.py` - Generate metadata from DB
- `scripts/extract_subjects_from_db.sql` - SQL query to export subjects
- `scripts/analyze_clustering.py` - Analyze clustering quality

## See Also

- [CLUSTERING_ANALYSIS.md](../CLUSTERING_ANALYSIS.md) - Detailed analysis of the model
- [SUMMARY.md](../SUMMARY.md) - Quick overview and next steps

