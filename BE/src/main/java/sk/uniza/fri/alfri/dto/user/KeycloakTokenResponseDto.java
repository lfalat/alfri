package sk.uniza.fri.alfri.dto.user;

import com.fasterxml.jackson.annotation.JsonProperty;

public record KeycloakTokenResponseDto(
        @JsonProperty("access_token") String accessToken,
        @JsonProperty("expires_in") long expiresIn
) {
}
