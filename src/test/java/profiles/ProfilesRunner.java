package profiles;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Profile Management module.
 *
 * <p>Executes {@code profiles.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/profiles} and the
 * {@code GET /api/v1/profiles/search} query endpoint.</p>
 */
class ProfilesRunner {

    /**
     * Runs every scenario inside the {@code profiles} package.
     */
    @Test
    void testProfiles() {
        Karate.run("profiles").relativeTo(getClass());
    }

}
