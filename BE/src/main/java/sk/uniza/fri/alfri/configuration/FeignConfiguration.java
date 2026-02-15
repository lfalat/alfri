package sk.uniza.fri.alfri.configuration;

import feign.Request;
import feign.RequestInterceptor;
import feign.Logger;
import feign.Response;
import feign.FeignException;
import feign.codec.ErrorDecoder;
import feign.Util;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import sk.uniza.fri.alfri.infrastructure.exception.PythonServiceServerException;

import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.Map;

@Configuration
public class FeignConfiguration {

    @Value("${python.service.api-key:}")
    private String apiKey;

    @Value("${python.service.timeout-ms:5000}")
    private int timeoutMs;

    @Bean
    public RequestInterceptor apiKeyRequestInterceptor() {
        return template -> {
            if (apiKey != null && !apiKey.isEmpty()) {
                template.header("X-API-Key", apiKey);
            }
        };
    }

    @Bean
    public Request.Options feignOptions() {
        // Use legacy int constructor for current feign version
        return new Request.Options(timeoutMs, timeoutMs);
    }

    @Bean
    Logger.Level feignLoggerLevel() {
        return Logger.Level.BASIC;
    }

    @Bean
    public ErrorDecoder errorDecoder() {
        return (methodKey, response) -> {
            int status = response.status();
            String bodyString = null;
            Response.Body originalBody = response.body();
            if (originalBody != null) {
                try {
                    // Read body contents (may be JSON with error details)
                    bodyString = Util.toString(originalBody.asReader(StandardCharsets.UTF_8));
                } catch (Exception e) {
                    bodyString = "<unable to read body: " + e.getMessage() + ">";
                }
            }
            // Log structured info for diagnostics
            System.err.println("[FeignError] method=" + methodKey + " status=" + status + " url=" + response.request().url());
            // Headers
            for (Map.Entry<String, Collection<String>> h : response.headers().entrySet()) {
                System.err.println("[FeignError] header " + h.getKey() + "=" + h.getValue());
            }
            if (bodyString != null) {
                System.err.println("[FeignError] body=" + bodyString);
            }
            if (status >= 500 && status < 600) {
                return new PythonServiceServerException("Python service 5xx error: status=" + status + (bodyString != null ? ", body=" + truncate(bodyString) : ""));
            }
            // Reconstruct response with consumed body so FeignException still contains it
            Response newResponse = response.toBuilder().body(bodyString, StandardCharsets.UTF_8).build();
            return FeignException.errorStatus(methodKey, newResponse);
        };
    }

    private String truncate(String s) {
        final int max = 500; // avoid logging extremely large bodies
        return s.length() <= max ? s : s.substring(0, max) + "...";
    }
}
