package componenttypes;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Component Type Management module.
 *
 * <p>Executes {@code component-types.feature}, which exercises the
 * {@code GET /api/v1/component-types} and
 * {@code POST /api/v1/component-types} endpoints.</p>
 */
class ComponentTypesRunner {

    /**
     * Runs every scenario inside the {@code componenttypes} package and
     * fails the build if any scenario errors.
     */
    @Test
    void testComponentTypes() {
        SuiteResult results = Runner
                .path("classpath:componenttypes")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "ComponentTypes scenarios failed - see target/karate-reports/");
    }

}
