package roles;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Role Management module.
 *
 * <p>Executes {@code roles.feature}, which exercises the
 * {@code GET /api/v1/roles} endpoint.</p>
 */
class RolesRunner {

    /**
     * Runs every scenario inside the {@code roles} package.
     */
    @Test
    void testRoles() {
        Karate.run("roles").relativeTo(getClass());
    }

}
