package requests;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Service Delivery Platform (SDP) Requests module.
 *
 * <p>Executes {@code requests.feature}, which exercises the full
 * request lifecycle under {@code /api/v1/requests}.</p>
 */
class RequestsRunner {

    /**
     * Runs every scenario inside the {@code requests} package.
     */
    @Test
    void testRequests() {
        Karate.run("requests").relativeTo(getClass());
    }

}
