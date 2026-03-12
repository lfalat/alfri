package sk.uniza.fri.alfri.configuration;

import io.jsonwebtoken.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
    private static final String APPLICATION_JSON = "application/json";
    private final JwtService jwtService;
  private final UserDetailsService userDetailsService;

    public JwtAuthenticationFilter(JwtService jwtService, UserDetailsService userDetailsService) {
    this.jwtService = jwtService;
    this.userDetailsService = userDetailsService;
  }

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response, @NonNull FilterChain filterChain)
            throws IOException, java.io.IOException, ServletException {
        final String authHeader = request.getHeader("Authorization");

        // TODO ak bude cas, je potrebne prerobit security config, aby tam fungovali endpointy, ktore
    // TODO nepotrebuju autentifikaciu. Teraz je potrebne ich specifikovat tu
    if ((request.getServletPath().startsWith("/api/auth")
            && !request.getServletPath().equals("/api/auth/change-password"))
        || request.getServletPath().startsWith("/api/user/roles")) {
      filterChain.doFilter(request, response);
      return;
    }

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType(APPLICATION_JSON);
            response.getWriter().write("{\"error\":\"Missing or invalid Authorization header\"}");
            return;
        }

        try {
            final String jwt = authHeader.substring(BEGIN_INDEX_OF_JWT);
            final String userName = jwtService.extractUsername(jwt);

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

            if (userName != null && authentication == null) {
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userName);

                if (jwtService.isTokenValid(jwt, userDetails)) {
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());

                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    response.setStatus(HttpStatus.UNAUTHORIZED.value());
                    response.setContentType(APPLICATION_JSON);
                    response.getWriter().write("{\"error\":\"Invalid or expired token\"}");
                    return;
                }
            }

            filterChain.doFilter(request, response);
        } catch (Exception e) {
            log.error("Error processing JWT token", e);
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType(APPLICATION_JSON);
            response.getWriter().write("{\"error\":\"Invalid token\"}");
        }
    }
}
