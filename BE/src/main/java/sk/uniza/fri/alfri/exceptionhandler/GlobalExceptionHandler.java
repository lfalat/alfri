package sk.uniza.fri.alfri.exceptionhandler;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import sk.uniza.fri.alfri.exception.InvalidCredentialsException;
import sk.uniza.fri.alfri.exception.PythonOutputParsingException;
import sk.uniza.fri.alfri.exception.QuestionnaireNotFilledException;
import sk.uniza.fri.alfri.exception.UserAlreadyRegisteredException;

import javax.naming.AuthenticationException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @ExceptionHandler(UserAlreadyRegisteredException.class)
    public ResponseEntity<Object> handleUserAlreadyRegisteredException(
            UserAlreadyRegisteredException ex, WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.CONFLICT, ex.getMessage(), request.getDescription(false));
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<Object> handleInvalidCredentialsException(InvalidCredentialsException ex,
                                                                    WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.UNAUTHORIZED, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<Object> handleAuthenticationException(AuthenticationException ex,
                                                                WebRequest request) {
        return buildResponseEntity(HttpStatus.FORBIDDEN, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<Object> handleEntityNotFoundException(EntityNotFoundException ex,
                                                                WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.NOT_FOUND, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(QuestionnaireNotFilledException.class)
    public ResponseEntity<Object> handleQuestionnaireNotFilledException(
            QuestionnaireNotFilledException ex, WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.NOT_FOUND, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Object> handleResourceNotFoundException(ResourceNotFoundException ex,
                                                                  WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.NOT_FOUND, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(ExpiredJwtException.class)
    public ResponseEntity<Object> handleExpiredJwtException(ExpiredJwtException ex,
                                                            WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.FORBIDDEN, "JWT token is expired!",
                request.getDescription(false));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Object> handleAccessDeniedException(AccessDeniedException ex,
                                                              WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.FORBIDDEN, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(PythonOutputParsingException.class)
    public ResponseEntity<Object> handlePythonOutputParsingException(PythonOutputParsingException ex,
                                                                     WebRequest request) {
        log.error(ex.getMessage());
        return buildResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR, ex.getMessage(),
                request.getDescription(false));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Object> handleGenericException(Exception ex, WebRequest request) {
        log.error("Unhandled exception: ", ex);
        return buildResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred.",
                request.getDescription(false));
    }

    private ResponseEntity<Object> buildResponseEntity(HttpStatus status, String message,
                                                       String path) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("status", status.value());
        body.put("error", status.getReasonPhrase());
        body.put("message", message);
        body.put("path", path);
        return new ResponseEntity<>(body, status);
    }
}
