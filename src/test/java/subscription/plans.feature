# plans/plans.feature
# ─────────────────────────────────────────────────────────────────
# Plan Management Module — Integration tests.
# Base Path: /api/v1/plans
# ─────────────────────────────────────────────────────────────────

Feature: Plan Management module - subscription plan catalog

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /plans — list every plan
  # ────────────────────────────────────────────────────────────────
  @smoke @plans @get
  Scenario: Get all plans returns an array of plans
    Given path '/plans'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { id: '#number', name: '#string', description: '##string', price: '#number', maxRequestsPerMonth: '#number', prioritySupport: '#boolean', isActive: '#boolean' })

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
  # plan name is the unique BASIC/PREMIUM enum and there is no DELETE /plans: a still-free
  # enum value can be created (201), but once both exist re-POSTing a taken name is rejected
  # (409).
  @regression @plans @post
  Scenario: Create plan returns 201 for a free name, or 409 for a duplicate
    Given path '/plans'
    When method GET
    Then status 200
    * def names = karate.map(response, function(p){ return p.name })
    * def freeName = names.contains('BASIC') ? (names.contains('PREMIUM') ? null : 'PREMIUM') : 'BASIC'
    * def nameToPost = freeName != null ? freeName : names[0]
    * def planBody = karate.merge(testData.newPlan, { name: nameToPost })

    Given path '/plans'
    And request planBody
    When method POST
    * def expectedStatus = freeName != null ? 201 : 409
    * match responseStatus == expectedStatus
    * def expectedBody = freeName != null ? { id: '#number', name: nameToPost, description: '##string', price: '#number', maxRequestsPerMonth: '#number', prioritySupport: '#boolean', isActive: '#boolean' } : { message: '#string' }
    * match response == expectedBody
