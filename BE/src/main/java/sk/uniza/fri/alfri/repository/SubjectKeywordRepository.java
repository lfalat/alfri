package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.SubjectKeyword;

import java.util.List;

public interface SubjectKeywordRepository extends JpaRepository<SubjectKeyword, Integer> {
    @Query("SELECT s FROM Subject s WHERE s.code IN (" +
            "SELECT k.subjectCode1 FROM SubjectKeyword k WHERE k.keyword = :keyword " +
            "UNION " +
            "SELECT k.subjectCode2 FROM SubjectKeyword k WHERE k.keyword = :keyword " +
            "UNION " +
            "SELECT k.subjectCode3 FROM SubjectKeyword k WHERE k.keyword = :keyword)")
    List<Subject> findSubjectsByKeyword(@Param("keyword") String keyword);

}
