package ratings;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Monitoring Ratings module.
 *
 * <p>Executes {@code ratings.feature}, which exercises every endpoint
 * under {@code /api/v1/ratings}.</p>
 */
class RatingsRunner {

    /**
     * Runs every scenario inside the {@code ratings} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testRatings() {
        SuiteResult results = Runner
                .path("classpath:ratings")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Ratings scenarios failed - see target/karate-reports/");
    }

}
