package sk.uniza.fri.alfri.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.Subject;

import java.util.List;

public interface FocusRepository extends JpaRepository<Focus, Integer> {

    @Query("SELECT DISTINCT f.subject FROM Focus f " +
            "WHERE (COALESCE(:mathFocus, 0) > 5 AND f.mathFocus > 5) OR " +
            "(COALESCE(:logicFocus, 0) > 5 AND f.logicFocus > 5) OR " +
            "(COALESCE(:programmingFocus, 0) > 5 AND f.programmingFocus > 5) OR " +
            "(COALESCE(:designFocus, 0) > 5 AND f.designFocus > 5) OR " +
            "(COALESCE(:economicsFocus, 0) > 5 AND f.economicsFocus > 5) OR " +
            "(COALESCE(:managementFocus, 0) > 5 AND f.managementFocus > 5) OR " +
            "(COALESCE(:hardwareFocus, 0) > 5 AND f.hardwareFocus > 5) OR " +
            "(COALESCE(:networkFocus, 0) > 5 AND f.networkFocus > 5) OR " +
            "(COALESCE(:dataFocus, 0) > 5 AND f.dataFocus > 5) OR " +
            "(COALESCE(:testingFocus, 0) > 5 AND f.testingFocus > 5) OR " +
            "(COALESCE(:languageFocus, 0) > 5 AND f.languageFocus > 5) OR " +
            "(COALESCE(:physicalFocus, 0) > 5 AND f.physicalFocus > 5)")
    List<Subject> findSubjectByHashMapValues(@Param("mathFocus") Integer mathFocus,
                                             @Param("logicFocus") Integer logicFocus,
                                             @Param("programmingFocus") Integer programmingFocus,
                                             @Param("designFocus") Integer designFocus,
                                             @Param("economicsFocus") Integer economicsFocus,
                                             @Param("managementFocus") Integer managementFocus,
                                             @Param("hardwareFocus") Integer hardwareFocus,
                                             @Param("networkFocus") Integer networkFocus,
                                             @Param("dataFocus") Integer dataFocus,
                                             @Param("testingFocus") Integer testingFocus,
                                             @Param("languageFocus") Integer languageFocus,
                                             @Param("physicalFocus") Integer physicalFocus);
}
