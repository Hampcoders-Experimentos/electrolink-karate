package ratings;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Monitoring Ratings module.
 *
 * <p>Executes {@code ratings.feature}, which exercises every endpoint
 * under {@code /api/v1/ratings}.</p>
 */
class RatingsRunner {

    /**
     * Runs every scenario inside the {@code ratings} package.
     */
    @Test
    void testRatings() {
        Karate.run("ratings").relativeTo(getClass());
    }

}
