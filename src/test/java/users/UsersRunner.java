package users;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the User Management module.
 *
 * <p>Executes {@code users.feature}, which exercises the read endpoints
 * {@code GET /api/v1/users} and {@code GET /api/v1/users/{userId}}.</p>
 */
class UsersRunner {

    /**
     * Runs every scenario inside the {@code users} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testUsers() {
        SuiteResult results = Runner
                .path("classpath:users")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Users scenarios failed - see target/karate-reports/");
    }

}
