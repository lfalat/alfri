package sk.uniza.fri.alfri.client.dto;

import java.util.List;

public class ClusteringRequestDto {
    private List<List<Double>> focusVectors;
    private String studyProgramId;
    private Integer n_clusters;

    public List<List<Double>> getFocusVectors() {
        return focusVectors;
    }

    public void setFocusVectors(List<List<Double>> focusVectors) {
        this.focusVectors = focusVectors;
    }

    public String getStudyProgramId() {
        return studyProgramId;
    }

    public void setStudyProgramId(String studyProgramId) {
        this.studyProgramId = studyProgramId;
    }

    public Integer getN_clusters() {
        return n_clusters;
    }

    public void setN_clusters(Integer n_clusters) {
        this.n_clusters = n_clusters;
    }
}

