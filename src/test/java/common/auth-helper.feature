# common/auth-helper.feature
# ─────────────────────────────────────────────────────────────────
# Shared authentication helper feature.
#
# This feature is NOT executed directly (marked with @ignore at the
# feature level). Other features call individual scenarios by tag:
#
#   * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
#   * def authToken = auth.authToken
#
# `callonce` ensures sign-in happens only once per parent feature,
# which is the recommended Karate v2 idiom for shared auth.
# ─────────────────────────────────────────────────────────────────

@ignore
Feature: Shared authentication helper

  # ────────────────────────────────────────────────────────────────
  # @signIn — Authenticate the seeded test user and expose the JWT
  # token. `testUser` is provided globally by karate-config.js.
  # ────────────────────────────────────────────────────────────────
  @signIn
  Scenario: Sign in the seeded test user and expose authToken
    Given url baseUrl
    And path '/authentication/sign-in'
    And request testUser
    When method POST
    Then status 200
    * def authToken = response.token
