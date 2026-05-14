import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotEquals;

/**
 * Master runner for the Electrolink Backend API integration suite.
 *
 * <p>Discovers and executes every {@code .feature} file beneath the listed
 * classpath roots in parallel, then fails the build if any scenario errored.</p>
 *
 * <p>Each classpath entry maps one-to-one to a module documented in
 * {@code ELECTROLINK_API_ENDPOINTS.md}.</p>
 */
class TestRunner {

    /**
     * Executes every Electrolink feature in parallel using five threads.
     *
     * <p>The {@link SuiteResult#getErrors()} collection must be empty for the
     * build to pass.</p>
     */
    @Test
    void runAll() {
        SuiteResult results = Runner
                .path(
                        "classpath:authentication",
                        "classpath:users",
                        "classpath:roles",
                        "classpath:components",
                        "classpath:componenttypes",
                        "classpath:properties",
                        "classpath:technicianinventories",
                        "classpath:profiles",
                        "classpath:analytics",
                        "classpath:requests",
                        "classpath:services",
                        "classpath:schedules",
                        "classpath:ratings",
                        "classpath:reports",
                        "classpath:photos",
                        "classpath:serviceoperations",
                        "classpath:subscriptions",
                        "classpath:plans"
                )
                .parallel(5);

        assertNotEquals(0, results.getErrors().size(), "There are failed tests!");
    }

}
