# users/users.feature
# ─────────────────────────────────────────────────────────────────
# User Management Module — Integration tests.
# Base Path: /api/v1/users
#
# Endpoints covered:
#   - GET /users
#   - GET /users/{userId}
#
# Real API contract (verified against the running backend):
#   • Each user is { id, username, roles } — no email, firstName,
#     lastName or createdAt fields are returned.
# ─────────────────────────────────────────────────────────────────

Feature: User Management module - read endpoints

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken

  # ────────────────────────────────────────────────────────────────
  # GET /users — list every user
  # ────────────────────────────────────────────────────────────────
  @smoke @users @get
  Scenario: Get all users returns an array of user objects
    Given path '/users'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":       '#number',
        "username": '#string',
        "roles":    '#array'
      }
      """
    And assert response.length > 0

  # ────────────────────────────────────────────────────────────────
  # GET /users/{userId} — fetch a specific user
  # ────────────────────────────────────────────────────────────────
  @smoke @users @get
  Scenario: Get user by id returns the expected user payload
    Given path '/users', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":       '#number',
        "username": '#string',
        "roles":    '#array'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # GET /users/{userId} — non-existent id returns 404
  # ────────────────────────────────────────────────────────────────
  @regression @users @get @negative
  Scenario: Get user by unknown id returns 404
    Given path '/users', 999999
    When method GET
    Then status 404
