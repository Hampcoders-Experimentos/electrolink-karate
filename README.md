# Electrolink Backend API - Karate v2 Integration Tests

End-to-end integration test suite for the **Electrolink Service Delivery Platform**
backend, authored against **Karate v2** with **Java 21+** and **Maven**.

Every scenario is derived directly from
[`ELECTROLINK_API_ENDPOINTS.md`](../../SpringBoot/electrolink-backend-api/ELECTROLINK_API_ENDPOINTS.md)
— no endpoints, payloads or response shapes are invented. The suite covers 100% of
the 18 documented modules.

---

## Quick Start

```bash
# 1. Start the Electrolink backend on http://localhost:8081 (default for this suite)
# 2. From the project root, run the full suite
mvn test

# 3. Open the HTML report
start target/karate-reports/karate-summary.html        # Windows
# open  target/karate-reports/karate-summary.html      # macOS / Linux
```

---

## Prerequisites

| Tool      | Minimum version | Notes                                                   |
|-----------|-----------------|---------------------------------------------------------|
| Java JDK  | **21**          | Karate v2 requires Java 21+ for Virtual Threads         |
| Maven     | 3.8+            |                                                         |
| Backend   | Running         | Electrolink API reachable at `http://localhost:8081/api/v1` |

```powershell
java -version   # 21 or higher (Java 26 also works)
mvn -version
```

---

## Project Structure

```
karate-demo/
├── pom.xml                                            # Maven configuration
└── src/test/java/
    ├── karate-config.js                               # Global config (baseUrl, env, headers)
    ├── logback-test.xml                               # Logging configuration
    ├── TestRunner.java                                # Master runner (every module in parallel)
    │
    ├── common/                                        # Shared helpers
    │   ├── auth-helper.feature                        #   @signIn callable scenario (JWT cache)
    │   └── test-data.json                             #   Request payloads quoted from the spec
    │
    ├── authentication/   authentication.feature  +  AuthenticationRunner.java
    ├── users/            users.feature           +  UsersRunner.java
    ├── roles/            roles.feature           +  RolesRunner.java
    ├── components/       components.feature      +  ComponentsRunner.java
    ├── componenttypes/   component-types.feature +  ComponentTypesRunner.java
    ├── properties/       properties.feature      +  PropertiesRunner.java
    ├── technicianinventories/
    │                     technician-inventories.feature + TechnicianInventoriesRunner.java
    ├── profiles/         profiles.feature        +  ProfilesRunner.java
    ├── analytics/        analytics.feature       +  AnalyticsRunner.java
    ├── requests/         requests.feature        +  RequestsRunner.java
    ├── services/         services.feature        +  ServicesRunner.java
    ├── schedules/        schedules.feature       +  SchedulesRunner.java
    ├── ratings/          ratings.feature         +  RatingsRunner.java
    ├── reports/          reports.feature         +  ReportsRunner.java
    ├── photos/           photos.feature          +  PhotosRunner.java
    ├── serviceoperations/
    │                     service-operations.feature + ServiceOperationsRunner.java
    ├── subscriptions/    subscriptions.feature   +  SubscriptionsRunner.java
    └── plans/            plans.feature           +  PlansRunner.java
```

---

## Endpoint Coverage

| Module                          | Base path                          | Scenarios |
|---------------------------------|------------------------------------|-----------|
| Authentication                  | `/api/v1/authentication`           | 2         |
| User Management                 | `/api/v1/users`                    | 3         |
| Role Management                 | `/api/v1/roles`                    | 1         |
| Component Management            | `/api/v1/components`               | 6         |
| Component Type Management       | `/api/v1/component-types`          | 2         |
| Property Management             | `/api/v1/properties`               | 6         |
| Technician Inventory            | `/api/v1/technician-inventories`   | 7         |
| Profile Management              | `/api/v1/profiles`                 | 8         |
| Analytics                       | `/api/v1/analytics`                | 3         |
| SDP - Requests                  | `/api/v1/requests`                 | 5         |
| SDP - Services                  | `/api/v1/services`                 | 5         |
| SDP - Schedules                 | `/api/v1` (technicians, schedules) | 4         |
| Monitoring - Ratings            | `/api/v1/ratings`                  | 8         |
| Monitoring - Reports            | `/api/v1/reports`                  | 5         |
| Monitoring - Report Photos      | `/api/v1/photos`                   | 1         |
| Monitoring - Service Operations | `/api/v1/service-operations`       | 5         |
| Subscription Management         | `/api/v1/subscriptions`            | 5         |
| Plan Management                 | `/api/v1/plans`                    | 3         |

---

## Running Tests

```bash
# Full suite (parallel across all 18 modules)
mvn test

# Master runner only
mvn test -Dtest=TestRunner

# A single module
mvn test -Dtest=AuthenticationRunner
mvn test -Dtest=ComponentsRunner
mvn test -Dtest=RatingsRunner

# By tag
mvn test -Dkarate.options="--tags @smoke"
mvn test -Dkarate.options="--tags @regression"
mvn test -Dkarate.options="--tags @post"

# By environment
mvn test -Dkarate.env=dev          # default — http://localhost:8081/api/v1
mvn test -Dkarate.env=staging      # http://localhost:8081/api/v1
mvn test -Dkarate.env=prod         # https://api.electrolink.com/api/v1

# Combine module + tag + environment
mvn test -Dtest=ProfilesRunner -Dkarate.env=staging -Dkarate.options="--tags @smoke"
```

---

## Tags

| Tag               | Description                                                |
|-------------------|------------------------------------------------------------|
| `@smoke`          | Fast, critical scenarios — green path                       |
| `@regression`     | Full regression coverage                                   |
| `@negative`       | Documented error responses (404, 400, 401)                 |
| `@get` `@post` `@put` `@delete` | Filter by HTTP verb                          |
| `@<module>`       | e.g. `@users`, `@components`, `@ratings`, `@subscriptions` |
| `@ignore`         | Callable helpers — never executed directly                 |

---

## Authentication Flow

Every authenticated feature shares a single JWT via `callonce`:

```gherkin
Background:
  * url baseUrl
  * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
  * def authToken = auth.authToken
  * header Authorization = 'Bearer ' + authToken
```

The seeded credentials (`user@example.com` / `password123`) and the helper's
`POST /authentication/sign-in` call come from `karate-config.js → testUser` and
`common/auth-helper.feature@signIn` respectively, so individual features never hard-code
auth details.

---

## Configuration

`src/test/java/karate-config.js` exposes:

| Variable          | Default                              | Purpose                              |
|-------------------|--------------------------------------|--------------------------------------|
| `baseUrl`         | `http://localhost:8081/api/v1`       | Resolved per `karate.env`            |
| `connectTimeout`  | 30 000 ms                            | HTTP connect timeout                 |
| `readTimeout`     | 30 000 ms                            | HTTP read timeout                    |
| `commonHeaders`   | `Content-Type` / `Accept: application/json` | Applied to every request       |
| `testUser`        | `{ email, password }`                | Consumed by `auth-helper.feature`    |

Override the environment at runtime: `mvn test -Dkarate.env=prod`.

---

## Reports

After `mvn test`:

- `target/karate-reports/karate-summary.html` — interactive HTML summary
- `target/karate-reports/*.html` — per-feature detailed report
- `target/karate.log` — full execution log
- `target/surefire-reports/` — JUnit XML for CI/CD

---

## Karate Features Demonstrated

- GET / POST / PUT / DELETE against every documented Electrolink endpoint
- Schema validation with fuzzy matchers (`#string`, `#number`, `#uuid`, `#array`, `#regex .+@.+`)
- Full-object schema assertions via heredoc `match response == """ { ... } """`
- Shared authentication helper through `callonce` (token cached per feature)
- Externalized request payloads in `common/test-data.json`
- Path params, query params and custom headers
- Per-environment configuration via `karate-config.js`
- Parallel execution from a single master `TestRunner`
- Tag-based filtering for smoke / regression / negative subsets
