package technicianinventories;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Technician Inventory module.
 *
 * <p>Executes {@code technician-inventories.feature}, which covers every
 * endpoint under {@code /api/v1/technician-inventories}.</p>
 */
class TechnicianInventoriesRunner {

    /**
     * Runs every scenario inside the {@code technicianinventories} package
     * and fails the build if any scenario errors.
     */
    @Test
    void testTechnicianInventories() {
        SuiteResult results = Runner
                .path("classpath:technicianinventories")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "TechnicianInventories scenarios failed - see target/karate-reports/");
    }

}
