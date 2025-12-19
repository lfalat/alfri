package sk.uniza.fri.alfri.infrastructure;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.client.WireMock;
import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import sk.uniza.fri.alfri.infrastructure.dto.*;
import sk.uniza.fri.alfri.service.PythonPredictionService;

import java.util.List;
import java.util.Map;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.post;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(properties = {
        "python.service.base-url=http://localhost:0",
        "python.service.api-key=test-key",
        "python.service.timeout-ms=2000"
})
@ActiveProfiles("test")
public class PythonMlClientIntegrationTests {

    static WireMockServer wireMockServer;

    @Autowired
    private PythonMlClient pythonMlClient;

    @Autowired
    private PythonPredictionService pythonPredictionService;

    @BeforeAll
    static void startWireMock() {
        wireMockServer = new WireMockServer(WireMockConfiguration.options().dynamicPort());
        wireMockServer.start();
        WireMock.configureFor("localhost", wireMockServer.port());
        System.setProperty("python.service.base-url", "http://localhost:" + wireMockServer.port());
    }

    @AfterAll
    static void stopWireMock() {
        if (wireMockServer != null) {
            wireMockServer.stop();
        }
    }

    @Test
    void passingChanceDeserializes() {
        String body = "{\n" +
                "  \"results\": {\n" +
                "    \"math\": { \"probability\": 0.75, \"percentage\": \"75%\" },\n" +
                "    \"english\": { \"probability\": 0.5, \"percentage\": \"50%\" }\n" +
                "  }\n" +
                "}";

        wireMockServer.stubFor(post("/api/v1/predictions/passing-chance")
                .willReturn(aResponse()
                        .withHeader("Content-Type", "application/json")
                        .withBody(body)
                        .withStatus(200)));

        PassingChanceRequestDto req = new PassingChanceRequestDto();
        req.setSubjects(Map.of("math", List.of(1.0, 2.0)));

        PassingChanceResponseDto resp = pythonMlClient.passingChance(req);

        assertThat(resp).isNotNull();
        assertThat(resp.getResults()).containsKey("math");
        ProbabilityResultDto math = resp.getResults().get("math");
        assertThat(math.getProbability()).isEqualTo(0.75);
        assertThat(math.getPercentage()).isEqualTo("75%");
    }

    @Test
    void passingChanceFallbackOnServerError() {
        wireMockServer.stubFor(post("/api/v1/predictions/passing-chance")
                .willReturn(aResponse()
                        .withStatus(500)));

        PassingChanceRequestDto req = new PassingChanceRequestDto();
        req.setSubjects(Map.of("math", List.of(1.0, 2.0)));

        PassingChanceResponseDto resp = pythonPredictionService.passingChance(req);
        assertThat(resp).isNotNull();
        assertThat(resp.getResults()).isEmpty();
    }
}
