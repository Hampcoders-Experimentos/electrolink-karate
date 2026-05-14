# common/auth-helper.feature
# ─────────────────────────────────────────────────────────────────
# Shared authentication helper feature.
#
# This feature is NOT executed directly (marked @ignore at feature level).
# Other features call individual scenarios by tag:
#
#   * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
#   * def authToken = auth.authToken
#
# `callonce` ensures the helper runs only once per parent feature, which
# is the recommended Karate v2 idiom for shared auth.
#
# The seeded test user is provided by karate-config.js as `testUser`.
# Because no fixture in the database guarantees that user exists, the
# helper is idempotent: it first tries to sign-up the user (ignoring the
# 400 "already exists" path on subsequent runs), then signs in.
# ─────────────────────────────────────────────────────────────────

@ignore
Feature: Shared authentication helper

  # ────────────────────────────────────────────────────────────────
  # @signIn — Ensure the test user exists and expose its JWT token.
  # ────────────────────────────────────────────────────────────────
  @signIn
  Scenario: Sign up (idempotent) and sign in the seeded test user
    # Step 1 — ensure the user exists. 201 = newly created, 400 = already
    # present. Either outcome is acceptable, so we don't assert status.
    Given url baseUrl
    And path '/authentication/sign-up'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "#(testUser.username)",
        "password": "#(testUser.password)",
        "roles":    ["ROLE_HOMEOWNER"]
      }
      """
    When method POST

    # Step 2 — authenticate and capture the JWT.
    Given url baseUrl
    And path '/authentication/sign-in'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "#(testUser.username)",
        "password": "#(testUser.password)"
      }
      """
    When method POST
    Then status 200
    * def authToken = response.token
