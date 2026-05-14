package services;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Service Delivery Platform (SDP) Services module.
 *
 * <p>Executes {@code services.feature}, which exercises the service
 * catalog CRUD under {@code /api/v1/services}.</p>
 */
class ServicesRunner {

    /**
     * Runs every scenario inside the {@code services} package.
     */
    @Test
    void testServices() {
        Karate.run("services").relativeTo(getClass());
    }

}
