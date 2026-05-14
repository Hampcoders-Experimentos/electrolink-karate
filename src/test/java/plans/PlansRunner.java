package plans;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Plan Management module.
 *
 * <p>Executes {@code plans.feature}, which exercises the
 * {@code GET /api/v1/plans}, {@code GET /api/v1/plans/{planId}} and
 * {@code POST /api/v1/plans} endpoints.</p>
 */
class PlansRunner {

    /**
     * Runs every scenario inside the {@code plans} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testPlans() {
        SuiteResult results = Runner
                .path("classpath:plans")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Plans scenarios failed - see target/karate-reports/");
    }

}
