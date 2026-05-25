package sk.uniza.fri.alfri.common.pagitation;

import sk.uniza.fri.alfri.exception.BadConditionException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SearchDefinition {
    /**
     * Search operators meaning <> not equal > greater or equal than < less or equal than : absolute
     * comparator ~ relative comparator ^ range comparator List of reserved characters in http
     * requests: delimiters — :/?#[]@, subdelimiters — !$&'()*+,;=
     */
    private static final String SEARCH_OPERATORS = "<>|:|<|>|~|\\^";
    private final Map<String, SearchCriteria> searchCriteriaMap = new HashMap<>();

    public SearchDefinition(String searchDefinitions) {
        if (searchDefinitions != null && !searchDefinitions.isBlank()) {
            this.assignSearchDefinitions(searchDefinitions);
        }
    }

    private static String extractConditionalOperator(String match, Pattern pattern,
                                                     String[] conditionParts) {
        Matcher matcher = pattern.matcher(match);

        String conditionOperator = matcher.find() ? matcher.group() : null;

        // Check if a condition contains all 2 parts
        if (conditionParts.length != 2) {
            String errorDetail = conditionOperator == null ? "Condition doesn't contain operator."
                    : "Condition contains too many operators, only one in each condition is allowed.";
            throw new BadConditionException(
                    "Search condition: '" + match + "' contains invalid chars. " + errorDetail);
        }
        return conditionOperator;
    }

    public List<SearchCriteria> getSearchCriteria() {
        return new ArrayList<>(this.searchCriteriaMap.values());
    }

    private void assignSearchDefinitions(String searchDefinitions) {
        String[] matches = searchDefinitions.split(",");

        for (String match : matches) {
            String[] conditionParts = match.split(SEARCH_OPERATORS, 2);
            Pattern pattern = Pattern.compile(SEARCH_OPERATORS);
            String conditionOperator = extractConditionalOperator(match, pattern, conditionParts);

            SearchCriteria searchCriteria =
                    this.searchCriteriaMap.get(conditionParts[0] + conditionOperator);

            if (searchCriteria == null) {
                searchCriteria =
                        new SearchCriteria(conditionParts[0], conditionOperator, conditionParts[1]);
            } else {
                searchCriteria.addValue(conditionParts[1]);
            }

            this.searchCriteriaMap.put(conditionParts[0] + conditionOperator, searchCriteria);

        }
    }

}
