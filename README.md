# Karate Testing

Integration test suite for the Electrolink backend API, built with [Karate](https://github.com/karatelabs/karate) **v2.0.10**, Maven, JUnit 6, and Java 26.

The project is organized as a set of API feature suites grouped by bounded context:

- `iam`
- `profiles`
- `analytics`
- `assets`
- `sdp`
- `monitoring`
- `subscription`

Shared helpers live under `src/test/java/common`.

## Prerequisites

- Java 26
- Maven 3.9+ recommended
- A running backend API compatible with the configured base URLs

## Project layout

```text
src/test/java/
  karate-config.js        # Global Karate configuration
  TestRunner.java         # Master runner for all suites
  common/                 # Shared helpers and test data
  iam/                    # IAM features and runner
  profiles/               # Profiles features and runner
  analytics/              # Analytics features and runner
  assets/                 # Assets features and runner
  sdp/                    # SDP features and runner
  monitoring/             # Monitoring features and runner
  subscription/           # Subscription features and runner
```

> Karate feature files are stored under `src/test/java` so they are available on the test classpath.

## Running the tests

Run the full suite:

```bash
mvn test
```

Run with a different Karate environment:

```bash
mvn test -Dkarate.env=staging
```

```bash
mvn test -Dkarate.env=prod
```

Run a specific runner:

```bash
mvn -Dtest=TestRunner test
```

You can also run an individual module runner by targeting its `*Runner` class with Surefire's `-Dtest` filter.

## Configuration

Global test configuration is defined in `src/test/java/karate-config.js`.

Default values:

- `karate.env`: `dev`
- `baseUrl`: `http://localhost:8081/api/v1`
- `connectTimeout`: `30000`
- `readTimeout`: `30000`

Environment-specific behavior:

- `dev`: default configuration
- `staging`: same local API base URL, explicitly logged
- `prod`: uses `https://api.electrolink.com/api/v1` and a longer connection timeout

Global headers are also configured there:

- `Content-Type: application/json`
- `Accept: application/json`

The shared test user is defined as:

- `username: user@example.com`
- `password: password123`

## Suite organization

The master runner (`src/test/java/TestRunner.java`) executes all feature files under these classpath roots:

- `classpath:iam`
- `classpath:profiles`
- `classpath:analytics`
- `classpath:assets`
- `classpath:sdp`
- `classpath:monitoring`
- `classpath:subscription`

Each bounded context also has its own runner, for example:

- `src/test/java/iam/IamRunner.java`
- `src/test/java/profiles/ProfilesRunner.java`
- `src/test/java/analytics/AnalyticsRunner.java`

## Shared helpers

Reusable test helpers are located in `src/test/java/common`:

- `auth-helper.feature` — idempotent sign-up/sign-in helper for retrieving a JWT token
- `seed-helper.feature` — helper for creating test fixtures
- `test-data.json` — shared payloads and test data

Example usage from a feature file:

```gherkin
* def auth = callonce read('classpath:common/auth-helper.feature@signIn')
* def authToken = auth.authToken
```

## Test execution notes

- JUnit parallel execution is disabled via `src/test/resources/junit-platform.properties`.
- The Maven Surefire plugin is configured to include `*Runner.java` and `*Test.java` classes.
- Test reports are generated under `target/karate-reports/` and `target/surefire-reports/`.

## Reports

After a run, open:

- `target/karate-reports/index.html`
- `target/karate-reports/karate-summary.html`
- `target/karate-reports/karate-timeline.html`

## Troubleshooting

If the suite fails early, verify that:

1. The backend API is running and reachable at the configured `baseUrl`.
2. The environment passed to Maven matches the backend you want to test.
3. The test user can be created or already exists in the backend.

If you need to inspect a failure in detail, check the generated HTML reports and the Maven console output.
