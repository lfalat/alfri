# Clustering Implementation - Summary & Next Steps

## TL;DR - Does it Make Sense?

### ✅ The clustering MODEL is good:
- 6 well-separated clusters representing different "subject profiles"
- 87 subjects distributed reasonably across clusters
- Clear patterns: some clusters are specialized (1-2 focus areas), others are multidisciplinary (5-7 focus areas)
- Converged in only 4 iterations = stable solution

### ❌ The clustering USAGE is broken:
- Returns cluster indices (e.g., `[2, 2, 5]`) instead of actual similar subjects
- No way to map cluster indices back to subject IDs/names
- The offset (+87 for Management) is just shifting numbers, not solving the problem
- **Cannot actually recommend similar subjects to users!**

---

## What's Missing

To make this work, you need from the Spring Boot backend:

### 1. Subject Entity Structure
```java
// What I need to see from ~/alfri/BE
class Subject {
    Long id;
    String name;
    StudyProgram studyProgram; // INF or Management
    List<Focus> focuses; // Should be 12 focuses per subject
}

class Focus {
    Long id;
    String name; // e.g., "Theoretical Knowledge", "Practical Skills", etc.
    Double value; // 0-10 scale
}
```

### 2. Training Data
The 87 subjects that were used to train the KMeans model:
- What are their IDs?
- What are their names?
- What cluster was each assigned to (from the `labels_` array)?

### 3. Focus Dimensions Meaning ✅ CONFIRMED
The 12 dimensions in the focus vector represent:
```
Index 0:  mathFocus        - Mathematical foundations and theory
Index 1:  logicFocus       - Logical thinking and reasoning
Index 2:  programmingFocus - Programming and coding skills
Index 3:  designFocus      - System and software design
Index 4:  economicsFocus   - Economics and business knowledge
Index 5:  managementFocus  - Project and team management
Index 6:  hardwareFocus    - Hardware and computer architecture
Index 7:  networkFocus     - Networking and distributed systems
Index 8:  dataFocus        - Data structures and databases
Index 9:  testingFocus     - Testing and quality assurance
Index 10: languageFocus    - Foreign language skills
Index 11: physicalFocus    - Physical education and sports
```

**Entity Structure (from Spring Boot BE):**
- **Subject**: id (Integer), name, code, abbreviation
- **Focus**: 1-to-1 with Subject, contains 12 Integer values (likely 0-10 scale)

---

## Example of What SHOULD Happen

### Current (Broken) Flow:
```
User selects: [Subject_42, Subject_17, Subject_8]
                ↓
Flask receives: {
  "focusVectors": [[...12 dims...], [...12 dims...], [...12 dims...]],
  "studyProgramId": 3
}
                ↓
KMeans predicts: cluster labels [2, 5, 2]
                ↓
Returns: {
  "cluster_indices": [2, 5, 2],  ← Useless! User wants subject IDs!
  "centroid": [...12 dims...]
}
```

### Correct Flow (Option 1 - Cluster-Based):
```
User selects: [Subject_42, Subject_17, Subject_8]
                ↓
Flask receives: {
  "subjectIds": [42, 17, 8],
  "studyProgramId": 3
}
                ↓
Flask looks up their clusters: [2, 5, 2]
                ↓
Flask finds all subjects in clusters 2 & 5:
  Cluster 2: [Subject_1, Subject_5, Subject_42, Subject_55, ...]
  Cluster 5: [Subject_3, Subject_17, Subject_23, ...]
                ↓
Compute distances from user's centroid, rank them
                ↓
Returns: {
  "recommendations": [
    {"id": 55, "name": "Advanced Algorithms", "cluster": 2, "similarity": 0.95},
    {"id": 23, "name": "Data Structures", "cluster": 5, "similarity": 0.87},
    {"id": 1, "name": "Software Engineering", "cluster": 2, "similarity": 0.82},
    ...
  ]
}
```

### Correct Flow (Option 2 - Distance-Based):
```
User selects: [Subject_42, Subject_17, Subject_8]
                ↓
Flask computes centroid of their focus vectors
                ↓
Calculate distance to ALL 87 subjects' focus vectors
                ↓
Return top 10 closest (excluding already selected)
                ↓
Returns: {
  "recommendations": [
    {"id": 55, "name": "Advanced Algorithms", "distance": 1.23},
    {"id": 23, "name": "Data Structures", "distance": 1.45},
    ...
  ]
}
```

---

## What I Need From You

### Option A: Give me access to the Spring Boot project
```bash
# Add to MCP server config or workspace
/home/klacek/alfri/BE
```
Then I can:
1. Read the Subject and Focus entities
2. Understand the data model
3. Propose exact implementation changes

### Option B: Export the data
Create a JSON file with the 87 subjects used for training:
```json
{
  "subjects": [
    {
      "id": 1,
      "name": "Introduction to Programming",
      "studyProgramId": 3,
      "clusterLabel": 2,
      "focusVector": [0.0, 7.5, 8.2, 6.1, 0.2, 1.4, 0.1, 0.3, 3.3, 4.5, 0.5, 0.0]
    },
    {
      "id": 2,
      "name": "Database Systems",
      "studyProgramId": 3,
      "clusterLabel": 2,
      "focusVector": [8.8, 8.5, 1.1, 0.7, 1.5, 0.5, 0.0, 0.4, 6.1, 0.3, 0.0, 0.0]
    },
    ...
  ],
  "focusDimensions": [
    "Theoretical Knowledge",
    "Practical Application",
    "Programming Skills",
    "Mathematical Foundations",
    "Teamwork & Collaboration",
    "Project Management",
    "Research & Analysis",
    "Communication Skills",
    "Technical Writing",
    "Problem Solving",
    "Creative Thinking",
    "Time Management"
  ]
}
```

Then I can:
1. Create this JSON file in the Flask server
2. Implement the correct recommendation logic
3. Update the API to accept subject IDs and return recommendations

### Option C: Just tell me the answers
1. What are the 12 focus dimensions?
2. How many subjects are in the INF program? Management program?
3. Do subjects have integer IDs?
4. Should the API return just IDs or full subject objects?

---

## Quick Wins

Even without the full data, I can:

1. **Fix the API contract** to be clearer about what it should do
2. **Add validation** that the focus vectors are 12-dimensional
3. **Document** what needs to be implemented
4. **Create a mock subjects.json** with dummy data to show how it should work

Want me to do any of these?

---

## Files Created

1. **CLUSTERING_ANALYSIS.md** - Detailed analysis of the clustering model
2. **scripts/dump_kmeans_pickle.py** - Script to extract pickle contents to JSON
3. **scripts/analyze_clustering.py** - Script to analyze clustering quality
4. **ml_service/models/kmeans_model_contents.json** - Extracted model data

Run the analysis anytime with:
```bash
python3 scripts/analyze_clustering.py
```

