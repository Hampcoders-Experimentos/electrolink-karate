package requests;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Service Delivery Platform (SDP) Requests module.
 *
 * <p>Executes {@code requests.feature}, which exercises the full request
 * lifecycle under {@code /api/v1/requests}.</p>
 */
class RequestsRunner {

    /**
     * Runs every scenario inside the {@code requests} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testRequests() {
        SuiteResult results = Runner
                .path("classpath:requests")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Requests scenarios failed - see target/karate-reports/");
    }

}
