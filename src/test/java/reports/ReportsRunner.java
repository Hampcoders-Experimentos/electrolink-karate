package reports;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Monitoring Reports module.
 *
 * <p>Executes {@code reports.feature}, which exercises every endpoint
 * under {@code /api/v1/reports}.</p>
 */
class ReportsRunner {

    /**
     * Runs every scenario inside the {@code reports} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testReports() {
        SuiteResult results = Runner
                .path("classpath:reports")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Reports scenarios failed - see target/karate-reports/");
    }

}
