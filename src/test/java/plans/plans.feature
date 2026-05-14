# plans/plans.feature
# ─────────────────────────────────────────────────────────────────
# Plan Management Module — Integration tests.
# Base Path: /api/v1/plans
#
# Endpoints covered:
#   - GET  /plans
#   - GET  /plans/{planId}
#   - POST /plans
# ─────────────────────────────────────────────────────────────────

Feature: Plan Management module - subscription plan catalog

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    # The spec separates user and admin tokens. This suite has only one sign-in
    # endpoint, so we reuse the same JWT for the admin-only POST /plans scenario.
    * def adminToken = authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /plans — list every plan
  # ────────────────────────────────────────────────────────────────
  @smoke @plans @get
  Scenario: Get all plans returns an array of plans
    Given path '/plans'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":           '#number',
        "name":         '#string',
        "description":  '#string',
        "price":        '#number',
        "currency":     '#string',
        "billingCycle": '#string',
        "features":     '#array'
      }
      """
    And assert response.length > 0

  # ────────────────────────────────────────────────────────────────
  # GET /plans/{planId} — fetch a plan
  # ────────────────────────────────────────────────────────────────
  @smoke @plans @get
  Scenario: Get plan by id returns the expected plan
    Given path '/plans', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "name":         '#string',
        "description":  '#string',
        "price":        '#number',
        "currency":     '#string',
        "billingCycle": '#string',
        "features":     '#array'
      }
      """
    And match response.name == 'Basic'

  # ────────────────────────────────────────────────────────────────
  # POST /plans — admin-only create plan
  # ────────────────────────────────────────────────────────────────
  @regression @plans @post
  Scenario: Create plan returns 201 with the created plan
    Given path '/plans'
    And header Authorization = 'Bearer ' + adminToken
    And request testData.newPlan
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":           '#number',
        "name":         '#string',
        "description":  '#string',
        "price":        '#number',
        "currency":     '#string',
        "billingCycle": '#string',
        "features":     '#array'
      }
      """
    And match response.name == 'Enterprise'
    And match response.price == 299.99
    And match response.currency == 'USD'
    And match response.billingCycle == 'MONTHLY'
    And assert response.features.length == 5
