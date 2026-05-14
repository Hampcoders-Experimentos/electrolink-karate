package analytics;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Analytics module.
 *
 * <p>Executes {@code analytics.feature}, which exercises the consumption,
 * performance and revenue endpoints under {@code /api/v1/analytics}.</p>
 */
class AnalyticsRunner {

    /**
     * Runs every scenario inside the {@code analytics} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testAnalytics() {
        SuiteResult results = Runner
                .path("classpath:analytics")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Analytics scenarios failed - see target/karate-reports/");
    }

}
