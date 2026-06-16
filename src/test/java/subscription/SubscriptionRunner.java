package subscription;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Subscription bounded context.
 *
 * <p>Executes every feature under {@code classpath:subscription} —
 * subscriptions and plans.</p>
 */
class SubscriptionRunner {

    /**
     * Runs every scenario inside the {@code subscription} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testSubscription() {
        SuiteResult results = Runner
                .path("classpath:subscription")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Subscription scenarios failed - see target/karate-reports/");
    }

}
