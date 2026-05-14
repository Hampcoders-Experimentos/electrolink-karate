package users;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the User Management module.
 *
 * <p>Executes {@code users.feature}, which exercises the read endpoints
 * {@code GET /api/v1/users} and {@code GET /api/v1/users/{userId}}.</p>
 */
class UsersRunner {

    /**
     * Runs every scenario inside the {@code users} package.
     */
    @Test
    void testUsers() {
        Karate.run("users").relativeTo(getClass());
    }

}
