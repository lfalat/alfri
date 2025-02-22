package sk.uniza.fri.alfri.repository;

import jakarta.persistence.Tuple;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.Subject;
import sk.uniza.fri.alfri.entity.SubjectKeyword;

import java.util.List;

public interface SubjectKeywordRepository extends JpaRepository<SubjectKeyword, Integer> {
    @Query("SELECT s FROM Subject s WHERE s IN (" +
            "SELECT k.subject1 FROM SubjectKeyword k WHERE k.keyword = :keyword " +
            "UNION " +
            "SELECT k.subject2 FROM SubjectKeyword k WHERE k.keyword = :keyword " +
            "UNION " +
            "SELECT k.subject3 FROM SubjectKeyword k WHERE k.keyword = :keyword)")
    List<Subject> findSubjectsByKeyword(@Param("keyword") String keyword);

    @Query("SELECT e.keyword FROM SubjectKeyword e WHERE e.keyword LIKE %:value%")
    List<String> searchKeywords(@Param("value") String value);

    @Query(nativeQuery = true, value = """
            SELECT keyword,
                   SUM(subject_1_occurence) +
                   SUM(subject_2_occurence) +
                   SUM(subject_3_occurence) AS count
            FROM public.subject_keyword
            GROUP BY keyword
            ORDER BY count DESC;
            """)
    List<Tuple> getAllSummed();
}
