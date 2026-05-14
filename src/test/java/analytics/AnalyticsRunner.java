package analytics;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Analytics module.
 *
 * <p>Executes {@code analytics.feature}, which exercises the consumption,
 * performance and revenue endpoints under {@code /api/v1/analytics}.</p>
 */
class AnalyticsRunner {

    /**
     * Runs every scenario inside the {@code analytics} package.
     */
    @Test
    void testAnalytics() {
        Karate.run("analytics").relativeTo(getClass());
    }

}
