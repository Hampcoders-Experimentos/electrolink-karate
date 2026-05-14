package profiles;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Profile Management module.
 *
 * <p>Executes {@code profiles.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/profiles} and the
 * {@code GET /api/v1/profiles/search} query endpoint.</p>
 */
class ProfilesRunner {

    /**
     * Runs every scenario inside the {@code profiles} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testProfiles() {
        SuiteResult results = Runner
                .path("classpath:profiles")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Profiles scenarios failed - see target/karate-reports/");
    }

}
