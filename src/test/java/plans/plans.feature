# plans/plans.feature
# ─────────────────────────────────────────────────────────────────
# Plan Management Module — Integration tests.
# Base Path: /api/v1/plans
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreatePlanResource = { name(BASIC|PREMIUM), description, price,
#                          maxRequestsPerMonth, prioritySupport }
#   PlanResource       = same fields + { id, isActive }
# ─────────────────────────────────────────────────────────────────

Feature: Plan Management module - subscription plan catalog

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
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
        "id":                  '#number',
        "name":                '#string',
        "description":         '##string',
        "price":               '#number',
        "maxRequestsPerMonth": '#number',
        "prioritySupport":     '#boolean',
        "isActive":            '#boolean'
      }
      """

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
        "id":                  '#number',
        "name":                '#string',
        "description":         '##string',
        "price":               '#number',
        "maxRequestsPerMonth": '#number',
        "prioritySupport":     '#boolean',
        "isActive":            '#boolean'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # POST /plans — create a plan
  # ────────────────────────────────────────────────────────────────
  @regression @plans @post
  Scenario: Create plan returns 201 with the created plan
    Given path '/plans'
    And request testData.newPlan
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":                  '#number',
        "name":                '#string',
        "description":         '##string',
        "price":               '#number',
        "maxRequestsPerMonth": '#number',
        "prioritySupport":     '#boolean',
        "isActive":            '#boolean'
      }
      """
    And match response.name == 'PREMIUM'
    And match response.price == 79.99
    And match response.maxRequestsPerMonth == 50
    And match response.prioritySupport == true
