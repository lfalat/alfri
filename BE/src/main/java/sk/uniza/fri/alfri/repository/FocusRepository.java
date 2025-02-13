package sk.uniza.fri.alfri.repository;

import jakarta.persistence.Tuple;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import sk.uniza.fri.alfri.dto.focus.FocusCategorySumDTO;
import sk.uniza.fri.alfri.entity.Focus;
import sk.uniza.fri.alfri.entity.Subject;

import java.util.List;

public interface FocusRepository extends JpaRepository<Focus, Integer> {

  @Query("SELECT DISTINCT f.subject FROM Focus f "
      + "WHERE (COALESCE(:mathFocus, 0) > 5 AND f.mathFocus > 5) OR "
      + "(COALESCE(:logicFocus, 0) > 5 AND f.logicFocus > 5) OR "
      + "(COALESCE(:programmingFocus, 0) > 5 AND f.programmingFocus > 5) OR "
      + "(COALESCE(:designFocus, 0) > 5 AND f.designFocus > 5) OR "
      + "(COALESCE(:economicsFocus, 0) > 5 AND f.economicsFocus > 5) OR "
      + "(COALESCE(:managementFocus, 0) > 5 AND f.managementFocus > 5) OR "
      + "(COALESCE(:hardwareFocus, 0) > 5 AND f.hardwareFocus > 5) OR "
      + "(COALESCE(:networkFocus, 0) > 5 AND f.networkFocus > 5) OR "
      + "(COALESCE(:dataFocus, 0) > 5 AND f.dataFocus > 5) OR "
      + "(COALESCE(:testingFocus, 0) > 5 AND f.testingFocus > 5) OR "
      + "(COALESCE(:languageFocus, 0) > 5 AND f.languageFocus > 5) OR "
      + "(COALESCE(:physicalFocus, 0) > 5 AND f.physicalFocus > 5)")
  List<Subject> findSubjectByHashMapValues(@Param("mathFocus") Integer mathFocus,
      @Param("logicFocus") Integer logicFocus, @Param("programmingFocus") Integer programmingFocus,
      @Param("designFocus") Integer designFocus, @Param("economicsFocus") Integer economicsFocus,
      @Param("managementFocus") Integer managementFocus,
      @Param("hardwareFocus") Integer hardwareFocus, @Param("networkFocus") Integer networkFocus,
      @Param("dataFocus") Integer dataFocus, @Param("testingFocus") Integer testingFocus,
      @Param("languageFocus") Integer languageFocus, @Param("physicalFocus") Integer physicalFocus);


  @Query(nativeQuery = true, value = """
    SELECT
        'math_focus' AS focus_category, SUM(math_focus) AS total_sum
    FROM public.focus
    UNION ALL
    SELECT
        'logic_focus', SUM(logic_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'programming_focus', SUM(programming_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'design_focus', SUM(design_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'economics_focus', SUM(economics_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'management_focus', SUM(management_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'hardware_focus', SUM(hardware_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'network_focus', SUM(network_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'data_focus', SUM(data_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'testing_focus', SUM(testing_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'language_focus', SUM(language_focus)
    FROM public.focus
    UNION ALL
    SELECT
        'physical_focus', SUM(physical_focus)
    FROM public.focus
    ORDER BY total_sum DESC;
    """)
  List<Tuple> findFocusCategorySums();
}
