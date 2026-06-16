import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Master runner for the Electrolink Backend API integration suite.
 *
 * <p>Discovers and executes every {@code .feature} file beneath the listed
 * classpath roots in parallel, then fails the build if any scenario errored.</p>
 */
class TestRunner {

    /**
     * <p>The {@link SuiteResult#getErrors()} collection must be empty for the
     * build to pass.</p>
     */
    @Test
    void runAll() {
        SuiteResult results = Runner
                .path(
                        "classpath:iam",
                        "classpath:profiles",
                        "classpath:analytics",
                        "classpath:assets",
                        "classpath:sdp",
                        "classpath:monitoring",
                        "classpath:subscription"
                )
                .parallel(1);

        assertEquals(0, results.getErrors().size(), "There are failed tests!");
    }

}
