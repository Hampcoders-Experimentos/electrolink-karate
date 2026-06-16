package sdp;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the SDP (Service Delivery Platform) bounded context.
 *
 * <p>Executes every feature under {@code classpath:sdp} — requests, services
 * and schedules.</p>
 */
class SdpRunner {

    /**
     * Runs every scenario inside the {@code sdp} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testSdp() {
        SuiteResult results = Runner
                .path("classpath:sdp")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "SDP scenarios failed - see target/karate-reports/");
    }

}
