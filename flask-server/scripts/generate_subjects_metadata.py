#!/usr/bin/env python3
"""
Generate subjects metadata JSON file with cluster labels from KMeans model.

This script:
1. Loads the KMeans model to get cluster labels for training data
2. Fetches subject data from Spring Boot database (or reads from exported JSON)
3. Combines them into a subjects_metadata.json file with cluster assignments

Usage:
  # Option 1: From database directly (requires psycopg2)
  python3 scripts/generate_subjects_metadata.py --db postgresql://user:pass@localhost:5432/alfri --study-program 3

  # Option 2: From exported JSON file
  python3 scripts/generate_subjects_metadata.py --input /tmp/subjects_inf.json --study-program 3
"""

import argparse
import json
import sys
from pathlib import Path
from typing import List, Dict, Any

REPO_ROOT = Path(__file__).resolve().parents[1]
KMEANS_JSON = REPO_ROOT / "ml_service" / "models" / "kmeans_model_contents.json"
OUTPUT_DIR = REPO_ROOT / "ml_service" / "models"


def load_kmeans_labels() -> List[int]:
    """Load cluster labels from the KMeans model JSON."""
    if not KMEANS_JSON.exists():
        print(f"Error: {KMEANS_JSON} not found. Run scripts/dump_kmeans_pickle.py first.")
        sys.exit(1)

    with open(KMEANS_JSON, "r") as f:
        data = json.load(f)

    labels = data.get("content", {}).get("labels_", [])
    if not labels:
        print("Error: No cluster labels found in KMeans model JSON.")
        sys.exit(1)

    return labels


def load_subjects_from_json(filepath: Path) -> List[Dict[str, Any]]:
    """Load subjects from exported JSON file."""
    with open(filepath, "r") as f:
        data = json.load(f)

    # Handle different JSON structures
    if isinstance(data, list):
        subjects = data
    elif isinstance(data, dict) and "subjects" in data:
        subjects = data["subjects"]
    else:
        print(f"Error: Unexpected JSON structure in {filepath}")
        sys.exit(1)

    return subjects


def load_subjects_from_db(db_url: str, study_program_id: int) -> List[Dict[str, Any]]:
    """Load subjects directly from PostgreSQL database."""
    try:
        import psycopg2
        from psycopg2.extras import RealDictCursor
    except ImportError:
        print("Error: psycopg2 not installed. Install with: pip install psycopg2-binary")
        sys.exit(1)

    conn = psycopg2.connect(db_url)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    query = """
        SELECT 
            s.subject_id as id,
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
            f.physical_focus
        FROM subject s
        INNER JOIN focus f ON s.subject_id = f.subject_id
        INNER JOIN study_program_subject sps ON s.subject_id = sps.subject_id
        WHERE sps.study_program_id = %s
        ORDER BY s.subject_id
        LIMIT 87
    """

    cur.execute(query, (study_program_id,))
    rows = cur.fetchall()
    cur.close()
    conn.close()

    # Convert to list of dicts with focus_vector
    subjects = []
    for row in rows:
        subject = dict(row)
        subject["focus_vector"] = [
            subject.pop("math_focus"),
            subject.pop("logic_focus"),
            subject.pop("programming_focus"),
            subject.pop("design_focus"),
            subject.pop("economics_focus"),
            subject.pop("management_focus"),
            subject.pop("hardware_focus"),
            subject.pop("network_focus"),
            subject.pop("data_focus"),
            subject.pop("testing_focus"),
            subject.pop("language_focus"),
            subject.pop("physical_focus"),
        ]
        subjects.append(subject)

    return subjects


def generate_metadata(subjects: List[Dict[str, Any]], labels: List[int], study_program_id: int) -> Dict[str, Any]:
    """Combine subjects with cluster labels into metadata structure."""
    if len(subjects) != len(labels):
        print(f"Warning: Subject count ({len(subjects)}) doesn't match label count ({len(labels)})")
        print(f"Using min of both: {min(len(subjects), len(labels))}")

    n = min(len(subjects), len(labels))

    subjects_with_clusters = []
    for i in range(n):
        subject = subjects[i].copy()
        subject["cluster_label"] = int(labels[i])
        subject["study_program_id"] = study_program_id
        subjects_with_clusters.append(subject)

    metadata = {
        "study_program_id": study_program_id,
        "n_subjects": n,
        "n_clusters": 6,
        "focus_dimensions": [
            "mathFocus",
            "logicFocus",
            "programmingFocus",
            "designFocus",
            "economicsFocus",
            "managementFocus",
            "hardwareFocus",
            "networkFocus",
            "dataFocus",
            "testingFocus",
            "languageFocus",
            "physicalFocus"
        ],
        "subjects": subjects_with_clusters
    }

    return metadata


def main():
    parser = argparse.ArgumentParser(description="Generate subjects metadata with cluster labels")
    parser.add_argument("--db", help="PostgreSQL connection URL")
    parser.add_argument("--input", help="Input JSON file with subjects")
    parser.add_argument("--study-program", type=int, required=True, help="Study program ID (3=INF, 4=Management)")
    parser.add_argument("--output", help="Output JSON file path")

    args = parser.parse_args()

    if not args.db and not args.input:
        print("Error: Either --db or --input must be provided")
        parser.print_help()
        sys.exit(1)

    # Load cluster labels
    print("Loading cluster labels from KMeans model...")
    labels = load_kmeans_labels()
    print(f"Loaded {len(labels)} cluster labels")

    # Load subjects
    if args.db:
        print(f"Fetching subjects from database for study program {args.study_program}...")
        subjects = load_subjects_from_db(args.db, args.study_program)
    else:
        print(f"Loading subjects from {args.input}...")
        subjects = load_subjects_from_json(Path(args.input))

    print(f"Loaded {len(subjects)} subjects")

    # Generate metadata
    metadata = generate_metadata(subjects, labels, args.study_program)

    # Determine output path
    if args.output:
        output_path = Path(args.output)
    else:
        program_name = "inf" if args.study_program == 3 else "management"
        output_path = OUTPUT_DIR / f"subjects_metadata_{program_name}.json"

    # Save
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(metadata, f, indent=2)

    print(f"\n✓ Generated metadata file: {output_path}")
    print(f"  - {metadata['n_subjects']} subjects")
    print(f"  - {metadata['n_clusters']} clusters")
    print(f"  - Study program ID: {metadata['study_program_id']}")

    # Print cluster distribution
    cluster_counts = {}
    for subj in metadata["subjects"]:
        cluster = subj["cluster_label"]
        cluster_counts[cluster] = cluster_counts.get(cluster, 0) + 1

    print("\n  Cluster distribution:")
    for cluster in sorted(cluster_counts.keys()):
        count = cluster_counts[cluster]
        print(f"    Cluster {cluster}: {count} subjects")


if __name__ == "__main__":
    main()

