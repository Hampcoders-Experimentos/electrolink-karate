package roles;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Role Management module.
 *
 * <p>Executes {@code roles.feature}, which exercises the
 * {@code GET /api/v1/roles} endpoint.</p>
 */
class RolesRunner {

    /**
     * Runs every scenario inside the {@code roles} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testRoles() {
        SuiteResult results = Runner
                .path("classpath:roles")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Roles scenarios failed - see target/karate-reports/");
    }

}
