package schedules;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Service Delivery Platform (SDP) Schedules module.
 *
 * <p>Executes {@code schedules.feature}, which exercises
 * {@code GET /api/v1/technicians/{technicianId}/schedules} and the
 * {@code /api/v1/schedules} CRUD endpoints.</p>
 */
class SchedulesRunner {

    /**
     * Runs every scenario inside the {@code schedules} package.
     */
    @Test
    void testSchedules() {
        Karate.run("schedules").relativeTo(getClass());
    }

}
