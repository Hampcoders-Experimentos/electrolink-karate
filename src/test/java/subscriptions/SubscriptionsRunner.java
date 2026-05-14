package subscriptions;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Subscription Management module.
 *
 * <p>Executes {@code subscriptions.feature}, which exercises every endpoint
 * under {@code /api/v1/subscriptions}.</p>
 */
class SubscriptionsRunner {

    /**
     * Runs every scenario inside the {@code subscriptions} package.
     */
    @Test
    void testSubscriptions() {
        Karate.run("subscriptions").relativeTo(getClass());
    }

}
