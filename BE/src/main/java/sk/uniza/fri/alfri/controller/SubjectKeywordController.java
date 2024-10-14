package sk.uniza.fri.alfri.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.service.implementation.SubjectKeywordService;

import java.util.List;

public class SubjectKeywordController {
    @Autowired
    private SubjectKeywordService keywordService;

    @GetMapping("/{keyword}/subjects")
    public ResponseEntity<List<Subject>> getSubjectsByKeyword(@PathVariable String keyword) {
        List<Subject> subjects = keywordService.getSubjectsByKeyword(keyword);
        if (!subjects.isEmpty()) {
            return ResponseEntity.ok(subjects);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
