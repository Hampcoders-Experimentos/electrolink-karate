package componenttypes;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Component Type Management module.
 *
 * <p>Executes {@code component-types.feature}, which exercises the
 * {@code GET /api/v1/component-types} and
 * {@code POST /api/v1/component-types} endpoints.</p>
 */
class ComponentTypesRunner {

    /**
     * Runs every scenario inside the {@code componenttypes} package.
     */
    @Test
    void testComponentTypes() {
        Karate.run("componenttypes").relativeTo(getClass());
    }

}
