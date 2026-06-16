# authentication/authentication.feature
# ─────────────────────────────────────────────────────────────────
# Authentication Module — Integration tests.
# Base Path: /api/v1/authentication
#
# Endpoints covered:
#   - POST /authentication/sign-up
#   - POST /authentication/sign-in
#
# Real API contract (verified against the running backend):
#   • Both endpoints accept `username` (NOT `email`) plus `password`.
#   • Sign-up additionally requires a non-empty `roles` array drawn from
#     the Roles enum: ROLE_HOMEOWNER, ROLE_TECHNICIAN, ROLE_CLIENT.
#   • Sign-up response: { id, username, roles }
#   • Sign-in response: { id, username, token }
#
# Notes on test isolation:
#   • The sign-up scenario uses a fresh random username every run, so
#     repeated executions never collide with existing accounts.
#   • The sign-in scenario performs an idempotent sign-up for the seeded
#     `testUser` (from karate-config.js) before authenticating.
# ─────────────────────────────────────────────────────────────────

Feature: Authentication module - sign-up and sign-in endpoints

  Background:
    * url baseUrl
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /authentication/sign-up — register a new user account
  # ────────────────────────────────────────────────────────────────
  @regression @authentication @post
  Scenario: Sign up creates a new user account with the requested role
    # Build a unique username per run so the test is fully repeatable
    # regardless of the existing state of the users table.
    * def randomSuffix = '' + Math.floor(Math.random() * 1000000000)
    * def newUsername = 'newuser_' + randomSuffix + '@example.com'

    Given path '/authentication/sign-up'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "username": "#(newUsername)",
        "password": "#(testData.signUp.password)",
        "roles":    ["ROLE_HOMEOWNER"]
      }
      """
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":       '#number',
        "username": '#string',
        "roles":    '#array'
      }
      """
    And match response.username == newUsername
    And match response.roles contains 'ROLE_HOMEOWNER'

  # ────────────────────────────────────────────────────────────────
  # POST /authentication/sign-up — duplicate username is rejected
  # ────────────────────────────────────────────────────────────────
  @regression @authentication @post @negative
  Scenario: Sign up with an already existing username is rejected
    # Build a unique username and create the account once.
    * def randomSuffix = '' + Math.floor(Math.random() * 1000000000)
    * def duplicateUsername = 'duplicate_' + randomSuffix + '@example.com'
    * def signUpBody =
      """
      {
        "username": "#(duplicateUsername)",
        "password": "#(testData.signUp.password)",
        "roles":    ["ROLE_HOMEOWNER"]
      }
      """

    Given path '/authentication/sign-up'
    And header Content-Type = 'application/json'
    And request signUpBody
    When method POST
    Then status 201
    And match response.username == duplicateUsername

    # Attempt to register the very same username again — must fail.
    Given path '/authentication/sign-up'
    And header Content-Type = 'application/json'
    And request signUpBody
    When method POST
    Then status 401

  # ────────────────────────────────────────────────────────────────
  # POST /authentication/sign-in — authenticate and retrieve token
  # ────────────────────────────────────────────────────────────────
  @smoke @authentication @post
  Scenario: Sign in returns the user id, username and a JWT token
    # Step 1 — ensure the seeded testUser exists. May return 201 (created)
    # on first run or any non-success code on subsequent runs if the user
    # already exists; either outcome is acceptable so we skip the assert.
    Given path '/authentication/sign-up'
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

    # Step 2 — sign in with the now-guaranteed credentials.
    Given path '/authentication/sign-in'
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
    And match response ==
      """
      {
        "id":       '#number',
        "username": '#string',
        "token":    '#string'
      }
      """
    And match response.username == testUser.username
    And match response.token != null
