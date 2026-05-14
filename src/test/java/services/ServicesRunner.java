package services;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Service Delivery Platform (SDP) Services module.
 *
 * <p>Executes {@code services.feature}, which exercises the service
 * catalog CRUD under {@code /api/v1/services}.</p>
 */
class ServicesRunner {

    /**
     * Runs every scenario inside the {@code services} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testServices() {
        SuiteResult results = Runner
                .path("classpath:services")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Services scenarios failed - see target/karate-reports/");
    }

}
