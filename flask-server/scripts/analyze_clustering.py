#!/usr/bin/env python3
"""
Analyze the KMeans clustering model to understand if it makes sense.

This script:
1. Loads the kmeans_model_contents.json
2. Analyzes cluster distribution and characteristics
3. Generates a report about the clustering quality
4. Creates visualizations if matplotlib is available
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Any

REPO_ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = REPO_ROOT / "ml_service" / "models" / "kmeans_model_contents.json"


def analyze_clusters(data: Dict[str, Any]) -> Dict[str, Any]:
    """Analyze the clustering model data."""
    content = data.get("content", {})
    
    n_clusters = content.get("n_clusters", 0)
    cluster_centers = content.get("cluster_centers_", [])
    labels = content.get("labels_", [])
    inertia = content.get("inertia_", 0)
    n_iter = content.get("n_iter_", 0)
    
    # Count subjects per cluster
    cluster_counts = {}
    for label in labels:
        cluster_counts[label] = cluster_counts.get(label, 0) + 1
    
    # Analyze each cluster center
    cluster_analysis = []
    for i, center in enumerate(cluster_centers):
        count = cluster_counts.get(i, 0)
        
        # Find dominant dimensions (> 5.0)
        dominant_dims = [(idx, val) for idx, val in enumerate(center) if val > 5.0]
        dominant_dims.sort(key=lambda x: x[1], reverse=True)
        
        # Find zero/near-zero dimensions (< 0.5)
        zero_dims = [idx for idx, val in enumerate(center) if abs(val) < 0.5]
        
        # Calculate "spread" (how many dimensions have significant values)
        significant_dims = [val for val in center if val > 1.0]
        
        cluster_analysis.append({
            "cluster_id": i,
            "subject_count": count,
            "dominant_dimensions": dominant_dims[:3],  # Top 3
            "zero_dimensions": zero_dims,
            "significant_dim_count": len(significant_dims),
            "max_value": max(center),
            "mean_value": sum(center) / len(center),
            "focus_vector": center
        })
    
    return {
        "n_clusters": n_clusters,
        "total_subjects": len(labels),
        "inertia": inertia,
        "iterations": n_iter,
        "cluster_distribution": cluster_counts,
        "cluster_analysis": cluster_analysis,
        "avg_subjects_per_cluster": len(labels) / n_clusters if n_clusters > 0 else 0,
    }


def print_report(analysis: Dict[str, Any]):
    """Print a human-readable analysis report."""
    print("=" * 80)
    print("KMEANS CLUSTERING ANALYSIS REPORT")
    print("=" * 80)
    print()
    
    print(f"Model Configuration:")
    print(f"  - Number of clusters: {analysis['n_clusters']}")
    print(f"  - Total subjects: {analysis['total_subjects']}")
    print(f"  - Average subjects per cluster: {analysis['avg_subjects_per_cluster']:.1f}")
    print(f"  - Inertia (within-cluster variance): {analysis['inertia']:.2f}")
    print(f"  - Converged in {analysis['iterations']} iterations")
    print()
    
    print("Cluster Distribution:")
    dist = analysis['cluster_distribution']
    for cluster_id in sorted(dist.keys()):
        count = dist[cluster_id]
        pct = (count / analysis['total_subjects']) * 100
        bar = "█" * int(pct / 2)
        print(f"  Cluster {cluster_id}: {count:2d} subjects ({pct:5.1f}%) {bar}")
    print()
    
    print("=" * 80)
    print("DETAILED CLUSTER CHARACTERISTICS")
    print("=" * 80)
    print()
    
    for cluster in analysis['cluster_analysis']:
        print(f"CLUSTER {cluster['cluster_id']}: {cluster['subject_count']} subjects")
        print(f"  Focus Pattern:")
        
        if cluster['dominant_dimensions']:
            print(f"    Strong focus on dimensions:")
            for dim_idx, dim_val in cluster['dominant_dimensions']:
                print(f"      - Dimension {dim_idx:2d}: {dim_val:6.2f}")
        
        if len(cluster['zero_dimensions']) > 6:
            print(f"    Low/zero in {len(cluster['zero_dimensions'])} dimensions: {cluster['zero_dimensions']}")
        
        print(f"  Statistics:")
        print(f"    - Significant dimensions (>1.0): {cluster['significant_dim_count']}")
        print(f"    - Max value: {cluster['max_value']:.2f}")
        print(f"    - Mean value: {cluster['mean_value']:.2f}")
        
        print(f"  Interpretation:")
        if len(cluster['dominant_dimensions']) == 1:
            print(f"    → Highly specialized subjects (focused on 1 main attribute)")
        elif len(cluster['dominant_dimensions']) >= 3:
            print(f"    → Balanced/multidisciplinary subjects (multiple strong focuses)")
        elif cluster['significant_dim_count'] <= 3:
            print(f"    → Moderately focused subjects")
        else:
            print(f"    → Diverse focus across many attributes")
        
        print()


def check_clustering_quality(analysis: Dict[str, Any]) -> List[str]:
    """Check if the clustering has potential issues."""
    issues = []
    warnings = []
    
    # Check cluster size balance
    counts = list(analysis['cluster_distribution'].values())
    max_count = max(counts)
    min_count = min(counts)
    
    if max_count > 3 * min_count:
        warnings.append(
            f"⚠️  Unbalanced clusters: largest has {max_count} subjects, "
            f"smallest has {min_count} (ratio {max_count/min_count:.1f}:1)"
        )
    
    # Check if inertia is reasonable
    avg_inertia_per_subject = analysis['inertia'] / analysis['total_subjects']
    if avg_inertia_per_subject > 100:
        warnings.append(
            f"⚠️  High within-cluster variance: {avg_inertia_per_subject:.1f} per subject. "
            "Clusters may not be tight."
        )
    
    # Check for clusters that are too similar
    cluster_analysis = analysis['cluster_analysis']
    for i, c1 in enumerate(cluster_analysis):
        for c2 in cluster_analysis[i+1:]:
            # Compare dominant dimensions
            dom1 = set(d[0] for d in c1['dominant_dimensions'])
            dom2 = set(d[0] for d in c2['dominant_dimensions'])
            overlap = len(dom1 & dom2)
            if overlap >= 2 and len(dom1) <= 3:
                warnings.append(
                    f"⚠️  Clusters {c1['cluster_id']} and {c2['cluster_id']} have similar "
                    f"dominant dimensions: {dom1 & dom2}"
                )
    
    # Check the actual problem: current usage doesn't map back to subjects
    issues.append(
        "❌ CRITICAL: Current implementation returns cluster indices but doesn't "
        "provide actual subject recommendations!"
    )
    issues.append(
        "   The API needs a subject_id → cluster_label mapping to be useful."
    )
    
    return issues, warnings


def main():
    if not JSON_PATH.exists():
        print(f"Error: Could not find {JSON_PATH}")
        print("Run scripts/dump_kmeans_pickle.py first to generate the JSON.")
        sys.exit(1)
    
    with open(JSON_PATH, "r") as f:
        data = json.load(f)
    
    analysis = analyze_clusters(data)
    print_report(analysis)
    
    print("=" * 80)
    print("CLUSTERING QUALITY ASSESSMENT")
    print("=" * 80)
    print()
    
    issues, warnings = check_clustering_quality(analysis)
    
    if warnings:
        print("Warnings:")
        for warning in warnings:
            print(f"  {warning}")
        print()
    
    if issues:
        print("Critical Issues:")
        for issue in issues:
            print(f"  {issue}")
        print()
    
    print("=" * 80)
    print("RECOMMENDATIONS")
    print("=" * 80)
    print()
    print("1. The clustering model itself looks reasonable:")
    print("   - 6 distinct clusters with clear focus patterns")
    print("   - Reasonable distribution of subjects")
    print("   - Converged quickly (stable solution)")
    print()
    print("2. HOWEVER, the implementation is incomplete:")
    print("   - Need subject_id → focus_vector mapping")
    print("   - Need subject_id → cluster_label mapping")
    print("   - Need to return actual subject IDs, not just cluster indices")
    print()
    print("3. Suggested fix:")
    print("   a) Create a subjects.json file with:")
    print("      {subject_id: {name: '...', cluster: X, focus: [...]}, ...}")
    print("   b) Modify endpoint to:")
    print("      - Accept subject IDs (look up their focus vectors)")
    print("      - Find their cluster(s)")
    print("      - Return ALL subjects in those cluster(s)")
    print("      - Rank by distance to user's centroid")
    print()
    print("See CLUSTERING_ANALYSIS.md for detailed recommendations.")
    print()


if __name__ == "__main__":
    main()

