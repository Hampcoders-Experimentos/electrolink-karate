package authentication;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Authentication module.
 *
 * <p>Executes {@code authentication.feature}, which exercises the
 * {@code POST /api/v1/authentication/sign-in} and
 * {@code POST /api/v1/authentication/sign-up} endpoints documented in
 * {@code ELECTROLINK_API_ENDPOINTS.md}.</p>
 */
class AuthenticationRunner {

    /**
     * Runs every scenario tagged inside the {@code authentication} package.
     */
    @Test
    void testAuthentication() {
        Karate.run("authentication").relativeTo(getClass());
    }

}
