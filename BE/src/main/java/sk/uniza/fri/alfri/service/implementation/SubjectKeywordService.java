package sk.uniza.fri.alfri.service.implementation;

import org.springframework.beans.factory.annotation.Autowired;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.repository.SubjectKeywordRepository;

import java.util.List;

public class SubjectKeywordService {
    @Autowired
    private SubjectKeywordRepository keywordRepository;

    public List<Subject> getSubjectsByKeyword(String keyword) {
        return keywordRepository.findSubjectsByKeyword(keyword);
    }
}
