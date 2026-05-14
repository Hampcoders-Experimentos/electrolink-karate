# authentication/authentication.feature
# ─────────────────────────────────────────────────────────────────
# Authentication Module — Integration tests.
# Base Path: /api/v1/authentication
#
# Endpoints covered:
#   - POST /authentication/sign-in
#   - POST /authentication/sign-up
# ─────────────────────────────────────────────────────────────────

Feature: Authentication module - sign-in and sign-up endpoints

  Background:
    * url baseUrl
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /authentication/sign-in — authenticate and retrieve token
  # ────────────────────────────────────────────────────────────────
  @smoke @authentication @post
  Scenario: Sign in returns a JWT token and the user payload
    Given path '/authentication/sign-in'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "email": "user@example.com",
        "password": "password123"
      }
      """
    When method POST
    Then status 200
    And match response.token == '#string'
    And match response.user ==
      """
      {
        "id":        '#number',
        "email":     '#regex .+@.+',
        "firstName": '#string',
        "lastName":  '#string',
        "createdAt": '#string'
      }
      """
    And match response.user.email == 'user@example.com'

  # ────────────────────────────────────────────────────────────────
  # POST /authentication/sign-up — register a new user account
  # ────────────────────────────────────────────────────────────────
  @regression @authentication @post
  Scenario: Sign up creates a new user account
    Given path '/authentication/sign-up'
    And header Content-Type = 'application/json'
    And request testData.signUp
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":        '#number',
        "email":     '#regex .+@.+',
        "firstName": '#string',
        "lastName":  '#string',
        "createdAt": '#string'
      }
      """
    And match response.email == 'newuser@example.com'
    And match response.firstName == 'Jane'
    And match response.lastName == 'Smith'
