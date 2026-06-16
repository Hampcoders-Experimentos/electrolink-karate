package assets;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Assets bounded context.
 *
 * <p>Executes every feature under {@code classpath:assets} — components,
 * component-types, properties and technician-inventories.</p>
 */
class AssetsRunner {

    /**
     * Runs every scenario inside the {@code assets} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testAssets() {
        SuiteResult results = Runner
                .path("classpath:assets")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Assets scenarios failed - see target/karate-reports/");
    }

}
