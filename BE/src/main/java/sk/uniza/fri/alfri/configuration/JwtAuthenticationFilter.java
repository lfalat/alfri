package sk.uniza.fri.alfri.configuration;

import io.jsonwebtoken.io.IOException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
import org.springframework.web.servlet.HandlerExceptionResolver;
import sk.uniza.fri.alfri.exceptionhandler.GlobalExceptionHandler;
import sk.uniza.fri.alfri.service.implementation.JwtService;

/** Created by petos on 17/04/2024. */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
  private final HandlerExceptionResolver handlerExceptionResolver;

  private final JwtService jwtService;
  private final UserDetailsService userDetailsService;

  public JwtAuthenticationFilter(
      JwtService jwtService,
      UserDetailsService userDetailsService,
      HandlerExceptionResolver handlerExceptionResolver) {
    this.jwtService = jwtService;
    this.userDetailsService = userDetailsService;
    this.handlerExceptionResolver = handlerExceptionResolver;
  }

  @Override
  protected void doFilterInternal(
      @NonNull HttpServletRequest request,
      @NonNull HttpServletResponse response,
      @NonNull FilterChain filterChain)
      throws IOException {
    final String authHeader = request.getHeader("Authorization");

    try {

      if (authHeader == null || !authHeader.startsWith("Bearer ")) {
        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        filterChain.doFilter(request, response);
        return;
      }

      final String jwt = authHeader.substring(7);
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
    } catch (Exception exception) {
      response.setStatus(HttpStatus.UNAUTHORIZED.value());
      handlerExceptionResolver.resolveException(
          request, response, GlobalExceptionHandler.class, exception);
    }
  }
}
