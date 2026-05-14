package reports;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Monitoring Reports module.
 *
 * <p>Executes {@code reports.feature}, which exercises every endpoint
 * under {@code /api/v1/reports}.</p>
 */
class ReportsRunner {

    /**
     * Runs every scenario inside the {@code reports} package.
     */
    @Test
    void testReports() {
        Karate.run("reports").relativeTo(getClass());
    }

}
