package subscriptions;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Subscription Management module.
 *
 * <p>Executes {@code subscriptions.feature}, which exercises every endpoint
 * under {@code /api/v1/subscriptions}.</p>
 */
class SubscriptionsRunner {

    /**
     * Runs every scenario inside the {@code subscriptions} package and
     * fails the build if any scenario errors.
     */
    @Test
    void testSubscriptions() {
        SuiteResult results = Runner
                .path("classpath:subscriptions")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Subscriptions scenarios failed - see target/karate-reports/");
    }

}
