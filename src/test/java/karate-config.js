/**
 * karate-config.js
 * ─────────────────────────────────────────────────────────────────
 * Global configuration for the Electrolink Backend API test suite.
 *
 * Must live at the classpath root: src/test/java/karate-config.js
 *
 * Karate executes this function before every Feature, and every
 * property of the returned `config` object becomes a variable that
 * any .feature file can reference without importing anything.
 *
 * Compatible with Karate v2 (no syntax differences between 2.0.x).
 */
function fn() {

    // ── 1. Resolve the active environment ─────────────────────────
    // Override with: mvn test -Dkarate.env=prod
    // Defaults to 'dev' when not provided.
    var env = karate.env || 'dev';
    karate.log('==> Running tests against environment:', env);

    // ── 2. Base configuration ─────────────────────────────────────
    var config = {
        // Base URL exposed to features as: * url baseUrl
        baseUrl: 'http://localhost:8081/api/v1',

        // Default request timeouts (milliseconds)
        connectTimeout: 30000,
        readTimeout: 30000,

        // Headers applied to every outgoing request
        commonHeaders: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },

        // Seeded credentials used by common/auth-helper.feature@signIn.
        // The real backend authenticates by `username`, not `email`.
        testUser: {
            username: 'user@example.com',
            password: 'password123'
        }
    };

    // ── 3. Per-environment overrides ─────────────────────────────
    if (env === 'prod') {
        config.baseUrl = 'https://api.electrolink.com/api/v1';
        config.connectTimeout = 60000;
        karate.log('==> Production configuration applied');
    } else if (env === 'staging') {
        config.baseUrl = 'http://localhost:8081/api/v1';
        karate.log('==> Staging configuration applied');
    }

    // ── 4. Apply global Karate runtime settings ──────────────────
    karate.configure('headers', config.commonHeaders);
    karate.configure('connectTimeout', config.connectTimeout);
    karate.configure('readTimeout', config.readTimeout);
    karate.configure('ssl', true);

    return config;
}
