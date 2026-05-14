package authentication;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Authentication module.
 *
 * <p>Executes {@code authentication.feature}, which exercises the
 * {@code POST /api/v1/authentication/sign-in} and
 * {@code POST /api/v1/authentication/sign-up} endpoints documented in
 * {@code ELECTROLINK_API_ENDPOINTS.md}.</p>
 *
 * <p>The {@link Runner} API is used (rather than {@code Karate.run(...)})
 * so that the JUnit test actually fails when any scenario errors. The HTML
 * report is still emitted under {@code target/karate-reports/}.</p>
 */
class AuthenticationRunner {

    /**
     * Runs every scenario inside the {@code authentication} package and
     * fails the build if any scenario errors.
     */
    @Test
    void testAuthentication() {
        SuiteResult results = Runner
                .path("classpath:authentication")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Authentication scenarios failed - see target/karate-reports/");
    }

}
