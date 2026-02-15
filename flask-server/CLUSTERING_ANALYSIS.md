# Clustering Model Analysis

## Current Implementation

### Model Overview
- **Type**: sklearn KMeans clustering
- **Number of clusters**: 6
- **Input dimensions**: 12 (representing 12 focus attributes per subject)
- **Training data**: 87 subjects (based on labels_ array length)
- **Inertia**: 3344.03 (measure of within-cluster variance)
- **Iterations**: 4 (converged quickly)

### How It's Used (from clustering.py)

1. **Input**: User selects 1-3 subjects, each with a 12-dimensional focus vector
2. **Process**: 
   - Compute mean of selected subjects' focus vectors (centroid)
   - Use pre-trained KMeans to predict which cluster each selected subject belongs to
   - Return cluster indices (with offset based on study program)
3. **Output**: Cluster indices + centroid of selected subjects

## Problem with Current Approach ❌

### The Issue
The current implementation **predicts which cluster the user's selected subjects belong to**, but this doesn't actually find "similar subjects" in a meaningful way.

### Why It Doesn't Work
1. **KMeans.predict()** assigns input vectors to the nearest pre-trained cluster centroid
2. It returns cluster labels (0-5), not actual subject IDs or indices
3. The cluster indices alone don't tell you which other subjects are similar
4. The offset (+87 for Management) just shifts the numbers but doesn't provide meaningful recommendations

### Example Problem
If a user selects subjects that map to cluster 2:
- Current output: `{"cluster_indices": [2, 2], "centroid": [...]}`
- What the user needs: A list of other subject IDs that are also in cluster 2 or close to the centroid

## What Should Be Done Instead ✅

### Recommended Approach

There are two valid approaches depending on your goal:

#### Option 1: Cluster-Based Recommendation (Simple)
**Best for**: Finding subjects in the same category/group

```python
# Training phase (already done):
# - Fit KMeans on all 87 subject focus vectors
# - Store cluster labels for each subject ID

# Inference phase (needs to be implemented):
1. User selects subject(s) → Get their focus vectors
2. Compute mean focus vector (centroid)
3. Predict which cluster this centroid belongs to
4. Return ALL subjects that belong to the same cluster(s)
5. Optionally rank by distance to the user's centroid
```

**Required data structure**:
```python
{
  "subject_id": 1,
  "cluster_label": 2,
  "focus_vector": [0.1, 0.2, ..., 0.5]
}
```

#### Option 2: Distance-Based Recommendation (More Precise)
**Best for**: Finding most similar subjects regardless of cluster

```python
1. User selects subject(s) → Get their focus vectors
2. Compute mean focus vector (centroid)
3. Calculate euclidean distance from centroid to ALL subjects' focus vectors
4. Return top N closest subjects (excluding already selected ones)
```

This doesn't even need clustering! Just needs all subject vectors.

### What's Missing

To implement either approach, you need:

1. **Subject-to-Focus mapping**: Database/JSON mapping each subject ID to its 12D focus vector
2. **Subject-to-Cluster mapping**: Store which cluster each subject belongs to
3. **Reverse lookup**: Given a cluster ID, return all subject IDs in that cluster

## Cluster Centers Analysis

Looking at the 6 cluster centroids from your model:

### Cluster 0 (8 subjects)
```
[0.0, ~0, ~0, 0.0, 0.0, 0.0, 0.0, ~0, 0.0, ~0, 0.0, 8.75]
```
- **Pattern**: Almost all zeros except dimension 11 (8.75)
- **Interpretation**: Subjects focused heavily on one specific attribute (index 11)

### Cluster 1 (22 subjects - largest)
```
[0.59, 7.45, 7.32, 6.05, 0.23, 1.36, 0.14, 0.27, 3.27, 4.45, 0.45, ~0]
```
- **Pattern**: High values in dimensions 1-3, 8-9 (moderate in 4-5)
- **Interpretation**: Balanced mix focusing on multiple attributes

### Cluster 2 (17 subjects)
```
[8.82, 8.47, 1.12, 0.71, 1.47, 0.53, 0.0, 0.35, 6.12, 0.29, ~0, ~0]
```
- **Pattern**: Very high in dimensions 0-1, moderate in 4 and 8
- **Interpretation**: Strongly focused on first two attributes + some on attribute 8

### Cluster 3 (8 subjects)
```
[0.25, 5.5, 1.0, 1.25, 0.0, 7.0, 0.0, ~0, 0.38, ~0, 8.75, ~0]
```
- **Pattern**: High in dimensions 5 and 10, moderate in 1
- **Interpretation**: Focused on specific attributes 5 and 10

### Cluster 4 (11 subjects)
```
[3.27, 4.91, 0.0, 4.55, 9.73, 7.99, 0.0, ~0, 2.55, ~0, ~0, 0.0]
```
- **Pattern**: Very high in dimensions 4-5, moderate in 1, 3, 8
- **Interpretation**: Heavily focused on attributes 4 and 5

### Cluster 5 (21 subjects)
```
[1.24, 7.52, 6.24, 2.67, 0.57, 0.48, 5.19, 6.19, 0.86, 1.33, 0.48, 0.48]
```
- **Pattern**: High in dimensions 1, 2, 6, 7
- **Interpretation**: Balanced across dimensions 1, 2, 6, 7

### Observations
1. **Clusters are well-separated** by their focus patterns
2. **Different specializations** - each cluster represents subjects with different focus distributions
3. **Makes sense IF** the 12 dimensions represent meaningful focus categories (e.g., theoretical, practical, programming, math, etc.)

## Does the Clustering Make Sense?

### ✅ The clustering model itself is reasonable:
- 6 clusters for 87 subjects is appropriate (average 14-15 subjects per cluster)
- Converged in only 4 iterations (stable solution)
- Clear distinct patterns in cluster centers
- Good distribution of subjects across clusters

### ❌ The current usage/implementation is wrong:
- Only returns cluster indices, not similar subjects
- No way to map cluster indices back to actual subjects
- The offset mechanism (+87) seems arbitrary and confusing
- Missing the actual recommendation logic

## Recommendations

1. **Create a subject metadata file** with:
   ```json
   {
     "subjects": [
       {
         "id": 1,
         "name": "Introduction to Programming",
         "study_program_id": 3,
         "focus_vector": [0.1, 0.2, ..., 0.5],
         "cluster_label": 2
       },
       ...
     ]
   }
   ```

2. **Modify the clustering endpoint** to:
   - Accept subject IDs (not raw focus vectors)
   - Look up their focus vectors and clusters
   - Return list of similar subject IDs with similarity scores
   - Optionally include subject metadata (names, etc.)

3. **Add a new endpoint**: `GET /api/v1/clustering/subjects/{studyProgramId}`
   - Returns all subjects with their clusters for the study program
   - Useful for debugging and frontend display

4. **Document what the 12 dimensions mean**:
   - What does each index in the focus_vector represent?
   - This is crucial for validating if the clusters make semantic sense

## Questions to Answer

1. What do the 12 focus dimensions represent? (e.g., theoretical knowledge, practical skills, programming, mathematics, etc.)
2. Do you have a mapping of subject_id → focus_vector?
3. What are the actual subject names in each cluster? Do they make semantic sense?
4. Why the +87 offset for Management program? Are there really 87 subjects in INF and you're just adding an offset?
5. What should the API actually return? Subject IDs? Subject objects with metadata?

## Next Steps

To verify if clustering makes sense, I need to see:
1. The Subject entity from the Spring Boot backend
2. The Focus entity and how it relates to subjects
3. Sample data showing which subjects are in which clusters
4. The meaning of each of the 12 focus vector dimensions

Would you like me to:
- Create a script to analyze the training data if you provide subject metadata?
- Implement the corrected clustering logic once I understand the data model?
- Create visualization of the clusters to see if they make semantic sense?

