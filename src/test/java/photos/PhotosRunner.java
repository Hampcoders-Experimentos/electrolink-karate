package photos;

import io.karatelabs.junit6.Karate;
import org.junit.jupiter.api.Test;

/**
 * Runner for the Monitoring Report Photos module.
 *
 * <p>Executes {@code photos.feature}, which exercises the
 * {@code POST /api/v1/photos} endpoint.</p>
 */
class PhotosRunner {

    /**
     * Runs every scenario inside the {@code photos} package.
     */
    @Test
    void testPhotos() {
        Karate.run("photos").relativeTo(getClass());
    }

}
