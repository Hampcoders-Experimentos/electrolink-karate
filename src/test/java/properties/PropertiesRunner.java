package properties;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Property Management module.
 *
 * <p>Executes {@code properties.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/properties}.</p>
 */
class PropertiesRunner {

    /**
     * Runs every scenario inside the {@code properties} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testProperties() {
        SuiteResult results = Runner
                .path("classpath:properties")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Properties scenarios failed - see target/karate-reports/");
    }

}
