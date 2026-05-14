package properties;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Property Management module.
 *
 * <p>Executes {@code properties.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/properties}, including
 * {@code GET /api/v1/properties/owner/{ownerId}}.</p>
 */
class PropertiesRunner {

    /**
     * Runs every scenario inside the {@code properties} package.
     */
    @Test
    void testProperties() {
        Karate.run("properties").relativeTo(getClass());
    }

}
