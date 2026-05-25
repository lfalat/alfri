package sk.uniza.fri.alfri.configuration;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Setter
@Getter
@Configuration
@ConfigurationProperties(prefix = "python.service")
public class PythonServiceProperties {
    private String baseUrl;
    private String apiKey;
    private int timeoutMs = 5000;

}

