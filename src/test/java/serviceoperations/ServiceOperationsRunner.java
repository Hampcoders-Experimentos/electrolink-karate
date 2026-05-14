package serviceoperations;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Monitoring Service Operations module.
 *
 * <p>Executes {@code service-operations.feature}, which exercises every
 * endpoint under {@code /api/v1/service-operations}.</p>
 */
class ServiceOperationsRunner {

    /**
     * Runs every scenario inside the {@code serviceoperations} package and
     * fails the build if any scenario errors.
     */
    @Test
    void testServiceOperations() {
        SuiteResult results = Runner
                .path("classpath:serviceoperations")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "ServiceOperations scenarios failed - see target/karate-reports/");
    }

}
