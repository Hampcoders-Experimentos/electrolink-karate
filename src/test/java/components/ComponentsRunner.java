package components;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Component Management module.
 *
 * <p>Executes {@code components.feature}, which exercises the full CRUD
 * surface under {@code /api/v1/components}.</p>
 */
class ComponentsRunner {

    /**
     * Runs every scenario inside the {@code components} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testComponents() {
        SuiteResult results = Runner
                .path("classpath:components")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Components scenarios failed - see target/karate-reports/");
    }

}
