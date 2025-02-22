package sk.uniza.fri.alfri.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import sk.uniza.fri.alfri.dto.subject.SubjectExtendedDto;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.mapper.SubjectMapper;
import sk.uniza.fri.alfri.service.implementation.SubjectKeywordService;

import java.util.List;

@RequestMapping("/api/keyword")
@RestController
public class SubjectKeywordController {

    private final SubjectKeywordService keywordService;

    public SubjectKeywordController(SubjectKeywordService keywordService) {
        this.keywordService = keywordService;
    }

    @GetMapping("/{keyword}/subjects")
    public ResponseEntity<List<SubjectExtendedDto>> getSubjectsByKeyword(@PathVariable String keyword) {
        List<Subject> subjects = keywordService.getSubjectsByKeyword(keyword);

        if (subjects.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(subjects.stream().map(SubjectMapper.INSTANCE::toSubjectExtendedDto).toList());
    }

    @GetMapping("/search/{value}")
    public ResponseEntity<List<String>> getKeywordsByValue(@PathVariable String value) {
        List<String> keywords = keywordService.getKeywordsByValue(value);

        if (keywords.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(keywords);
    }
}
