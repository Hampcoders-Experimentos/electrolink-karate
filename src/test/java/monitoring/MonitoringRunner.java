package monitoring;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Monitoring bounded context.
 *
 * <p>Executes every feature under {@code classpath:monitoring} — service
 * operations, reports, ratings and report photos.</p>
 */
class MonitoringRunner {

    /**
     * Runs every scenario inside the {@code monitoring} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testMonitoring() {
        SuiteResult results = Runner
                .path("classpath:monitoring")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Monitoring scenarios failed - see target/karate-reports/");
    }

}
