package sk.uniza.fri.alfri.common.pagitation;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.MethodParameter;
import org.springframework.lang.Nullable;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

public class PagitationRequestQueryParameterResolver implements HandlerMethodArgumentResolver {
    public static final String DEFAULT_PAGE_PARAMETER = "page";
    public static final String DEFAULT_SIZE_PARAMETER = "size";
    public static final String DEFAULT_SEARCH_PARAMETER = "search";
    private static final String DEFAULT_PREFIX = "";
    private static final String DEFAULT_QUALIFIER_DELIMITER = "_";

    // TODO conf variable
    private int maxPageSizeFromProperties = 100;

    // TODO conf variable
    private int defaultPageSizeFromProperties = 20;

    private SortRequestQueryParameterResolver sortRequestQueryParameterResolver;

    public PagitationRequestQueryParameterResolver(
            SortRequestQueryParameterResolver sortRequestQueryParameterResolver) {
        this.sortRequestQueryParameterResolver = sortRequestQueryParameterResolver;
    }

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return PagitationRequestQuery.class.equals(parameter.getParameterType());
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        String pageStr =
                webRequest.getParameter(getParameterNameToUse(DEFAULT_PAGE_PARAMETER, parameter));
        String sizeStr =
                webRequest.getParameter(getParameterNameToUse(DEFAULT_SIZE_PARAMETER, parameter));
        String searchStr =
                webRequest.getParameter(getParameterNameToUse(DEFAULT_SEARCH_PARAMETER, parameter));

        int page = Integer.parseInt(pageStr);
        int size = Integer.parseInt(sizeStr);
        SortDefinition sortDefinition;
        try {
            sortDefinition = sortRequestQueryParameterResolver.resolveArgument(parameter, mavContainer,
                    webRequest, binderFactory);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return PagitationRequestQuery.of(page, size, searchStr, sortDefinition);
    }

    protected String getParameterNameToUse(String source, @Nullable MethodParameter parameter) {

        StringBuilder builder = new StringBuilder(DEFAULT_PREFIX);

        Qualifier qualifier =
                parameter == null ? null : parameter.getParameterAnnotation(Qualifier.class);

        if (qualifier != null) {
            builder.append(qualifier.value());
            builder.append(DEFAULT_QUALIFIER_DELIMITER);
        }

        return builder.append(source).toString();
    }
}
