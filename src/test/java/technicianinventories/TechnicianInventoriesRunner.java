package technicianinventories;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Technician Inventory module.
 *
 * <p>Executes {@code technician-inventories.feature}, which covers every
 * endpoint under {@code /api/v1/technician-inventories}.</p>
 */
class TechnicianInventoriesRunner {

    /**
     * Runs every scenario inside the {@code technicianinventories} package.
     */
    @Test
    void testTechnicianInventories() {
        Karate.run("technician-inventories").relativeTo(getClass());
    }

}
