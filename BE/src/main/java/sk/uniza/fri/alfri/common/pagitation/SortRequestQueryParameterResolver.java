package sk.uniza.fri.alfri.common.pagitation;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.MethodParameter;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SortRequestQueryParameterResolver implements HandlerMethodArgumentResolver {
    private static final String DEFAULT_PARAMETER = "sort";
    private static final String DEFAULT_PROPERTY_DELIMITER = ",";
    private static final String DEFAULT_QUALIFIER_DELIMITER = "_";
    private String sortParameter = DEFAULT_PARAMETER;
    private String propertyDelimiter = DEFAULT_PROPERTY_DELIMITER;
    private String qualifierDelimiter = DEFAULT_QUALIFIER_DELIMITER;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return SortDefinition.class.equals(parameter.getParameterType());
    }

    @Override
    public SortDefinition resolveArgument(MethodParameter parameter,
                                          ModelAndViewContainer mavContainer, NativeWebRequest webRequest,
                                          WebDataBinderFactory binderFactory) throws Exception {
        String[] directionParameter = webRequest.getParameterValues(getSortParameter(parameter));

        if (directionParameter == null) {
            return null;
        }

        return parseParameterIntoSort(directionParameter, propertyDelimiter);
    }

    protected String getSortParameter(MethodParameter parameter) {

        StringBuilder builder = new StringBuilder();

        Qualifier qualifier =
                parameter != null ? parameter.getParameterAnnotation(Qualifier.class) : null;

        if (qualifier != null) {
            builder.append(qualifier.value()).append(qualifierDelimiter);
        }

        return builder.append(sortParameter).toString();
    }

    SortDefinition parseParameterIntoSort(String[] source, String delimiter) {

        List<OrderRequestQuery> allOrders = new ArrayList<>();

        for (String part : source) {
            if (part == null) {
                continue;
            }
            String[] elements = part.split(delimiter);

            Optional<DirectionRequestQueryEnum> direction = elements.length == 0 ? Optional.empty()
                    : DirectionRequestQueryEnum.fromOptionalString(elements[elements.length - 1]);

            int lastIndex = direction.map(it -> elements.length - 1).orElseGet(() -> elements.length);

            for (int i = 0; i < lastIndex; i++) {
                toOrder(elements[i], direction).ifPresent(allOrders::add);
            }
        }

        return allOrders.isEmpty() ? null : SortDefinition.by(allOrders);
    }

    private static Optional<OrderRequestQuery> toOrder(String property,
                                                       Optional<DirectionRequestQueryEnum> direction) {

        if (!StringUtils.hasText(property)) {
            return Optional.empty();
        }

        return Optional.of(direction.map(it -> new OrderRequestQuery(it, property))
                .orElseGet(() -> OrderRequestQuery.by(property)));
    }
}
