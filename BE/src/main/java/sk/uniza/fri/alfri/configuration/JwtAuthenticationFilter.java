package sk.uniza.fri.alfri.configuration;

import io.jsonwebtoken.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Arrays;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import sk.uniza.fri.alfri.service.implementation.JwtService;

@Component
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {
  public static final int BEGIN_INDEX_OF_JWT = 7;
  public static final String DEV_PROFILE = "dev";
  private final JwtService jwtService;
  private final UserDetailsService userDetailsService;
  private final Environment environment;

  @Value("${default-user-email}")
  private String defaultUserEmail;

  @Value("${default-user-roles}")
  private String[] defaultUserRoles;

  public JwtAuthenticationFilter(
      JwtService jwtService, UserDetailsService userDetailsService, Environment environment) {
    this.jwtService = jwtService;
    this.userDetailsService = userDetailsService;
    this.environment = environment;
  }

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws IOException, java.io.IOException, ServletException {
    final String authHeader = request.getHeader("Authorization");

    if (environment.getActiveProfiles().length != 0
        && Arrays.stream(environment.getActiveProfiles())
            .allMatch(profile -> profile.equals(DEV_PROFILE))) {
      log.info(Arrays.toString(environment.getActiveProfiles()));

      UserDetails devUserDetails =
          User.builder()
              .username(defaultUserEmail)
              .password("") // Empty password as it's not needed here
              .roles(defaultUserRoles)
              .build();

      UsernamePasswordAuthenticationToken devAuthToken =
          new UsernamePasswordAuthenticationToken(
              devUserDetails, null, devUserDetails.getAuthorities());

      devAuthToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
      SecurityContextHolder.getContext().setAuthentication(devAuthToken);

      filterChain.doFilter(request, response);
      return;
    }

    // TODO ak bude cas, je potrebne prerobit security config, aby tam fungovali endpointy, ktore
    // TODO nepotrebuju autentifikaciu. Teraz je potrebne ich specifikovat tu
    if (request.getServletPath().startsWith("/api/auth")
        || request.getServletPath().startsWith("/api/user/roles")) {
      filterChain.doFilter(request, response);
      return;
    }

    if (authHeader == null || !authHeader.startsWith("Bearer ")) {
      response.setStatus(HttpStatus.FORBIDDEN.value());
      filterChain.doFilter(request, response);
      return;
    }

    final String jwt = authHeader.substring(BEGIN_INDEX_OF_JWT);
    final String userName = jwtService.extractUsername(jwt);

    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    if (userName != null && authentication == null) {
      UserDetails userDetails = this.userDetailsService.loadUserByUsername(userName);

      if (jwtService.isTokenValid(jwt, userDetails)) {
        UsernamePasswordAuthenticationToken authToken =
            new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(authToken);
      }
    }

    filterChain.doFilter(request, response);
  }
}
