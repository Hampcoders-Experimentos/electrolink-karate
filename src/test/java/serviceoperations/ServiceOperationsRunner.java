package serviceoperations;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Monitoring Service Operations module.
 *
 * <p>Executes {@code service-operations.feature}, which exercises every
 * endpoint under {@code /api/v1/service-operations}.</p>
 */
class ServiceOperationsRunner {

    /**
     * Runs every scenario inside the {@code serviceoperations} package.
     */
    @Test
    void testServiceOperations() {
        Karate.run("service-operations").relativeTo(getClass());
    }

}
