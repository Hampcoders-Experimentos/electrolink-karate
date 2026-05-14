package photos;

import io.karatelabs.core.Runner;
import io.karatelabs.core.SuiteResult;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Runner for the Monitoring Report Photos module.
 *
 * <p>Executes {@code photos.feature}, which exercises the
 * {@code POST /api/v1/photos} endpoint.</p>
 */
class PhotosRunner {

    /**
     * Runs every scenario inside the {@code photos} package and fails
     * the build if any scenario errors.
     */
    @Test
    void testPhotos() {
        SuiteResult results = Runner
                .path("classpath:photos")
                .parallel(1);
        assertEquals(0, results.getErrors().size(),
                "Photos scenarios failed - see target/karate-reports/");
    }

}
