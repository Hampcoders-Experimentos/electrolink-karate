package iam;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the IAM bounded context.
 *
 * <p>Executes every feature under {@code classpath:iam} — authentication
 * (sign-in/sign-up), users and roles.</p>
 */
class IamRunner {

    /**
     * Runs every scenario inside the {@code iam} package and fails the
     * build if any scenario errors.
     */
    @Test
    void testIam() {
        SuiteResult results = Runner
                .path("classpath:iam")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "IAM scenarios failed - see target/karate-reports/");
    }

}
