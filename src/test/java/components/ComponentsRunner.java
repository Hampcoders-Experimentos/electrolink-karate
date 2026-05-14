package components;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Component Management module.
 *
 * <p>Executes {@code components.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/components}.</p>
 */
class ComponentsRunner {

    /**
     * Runs every scenario inside the {@code components} package.
     */
    @Test
    void testComponents() {
        Karate.run("components").relativeTo(getClass());
    }

}
