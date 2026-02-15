package sk.uniza.fri.alfri.client.dto;

import java.util.List;

public class ClusteringResponseDto {
    private String studyProgramId;
    private int offset_applied;
    private List<Integer> cluster_indices;
    private List<Double> centroid;

    public String getStudyProgramId() {
        return studyProgramId;
    }

    public void setStudyProgramId(String studyProgramId) {
        this.studyProgramId = studyProgramId;
    }

    public int getOffset_applied() {
        return offset_applied;
    }

    public void setOffset_applied(int offset_applied) {
        this.offset_applied = offset_applied;
    }

    public List<Integer> getCluster_indices() {
        return cluster_indices;
    }

    public void setCluster_indices(List<Integer> cluster_indices) {
        this.cluster_indices = cluster_indices;
    }

    public List<Double> getCentroid() {
        return centroid;
    }

    public void setCentroid(List<Double> centroid) {
        this.centroid = centroid;
    }
}

