package sk.uniza.fri.alfri.common.pagitation;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {
  @Override
  public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
    SortRequestQueryParameterResolver sortResolver = new SortRequestQueryParameterResolver();
    argumentResolvers.add(new PagitationRequestQueryParameterResolver(sortResolver));
    argumentResolvers.add(sortResolver);
  }
}
