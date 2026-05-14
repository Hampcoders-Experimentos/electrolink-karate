package plans;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Plan Management module.
 *
 * <p>Executes {@code plans.feature}, which exercises the
 * {@code GET /api/v1/plans}, {@code GET /api/v1/plans/{planId}} and
 * {@code POST /api/v1/plans} endpoints.</p>
 */
class PlansRunner {

    /**
     * Runs every scenario inside the {@code plans} package.
     */
    @Test
    void testPlans() {
        Karate.run("plans").relativeTo(getClass());
    }

}
