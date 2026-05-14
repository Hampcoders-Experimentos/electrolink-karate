package schedules;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Service Delivery Platform (SDP) Schedules module.
 *
 * <p>Executes {@code schedules.feature}, which exercises
 * {@code GET /api/v1/technicians/{technicianId}/schedules} and the
 * {@code /api/v1/schedules} CRUD endpoints.</p>
 */
class SchedulesRunner {

    /**
     * Runs every scenario inside the {@code schedules} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testSchedules() {
        SuiteResult results = Runner
                .path("classpath:schedules")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Schedules scenarios failed - see target/karate-reports/");
    }

}
