# subscriptions/subscriptions.feature
# ─────────────────────────────────────────────────────────────────
# Subscription Management Module — Integration tests.
# Base Path: /api/v1/subscriptions
# ─────────────────────────────────────────────────────────────────

Feature: Subscription Management module - user subscription lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def plan = callonce read('classpath:common/seed-helper.feature@plan')
    * def newSub = function(){ return karate.merge(testData.newSubscription, { planId: plan.planId, userId: Math.floor(Math.random() * 1000000000) + 1000 }) }

  # ────────────────────────────────────────────────────────────────
  # POST /subscriptions — create a subscription
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @post
  Scenario: Create subscription returns 201 with the new subscription
    * def sub = newSub()
    Given path '/subscriptions'
    And request sub
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":                  '#number',
        "userId":              '#number',
        "planId":              '#number',
        "planName":            '#string',
        "status":              '#string',
        "startDate":           '#string',
        "monthlyRequestCount": '#number',
        "canMakeRequest":      '#boolean'
      }
      """
    And match response.userId == sub.userId
    And match response.planId == sub.planId

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get subscription by user id returns the user's subscription
    * def sub = newSub()
    Given path '/subscriptions'
    And request sub
    When method POST
    Then status 201

    Given path '/subscriptions/users', sub.userId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                  '#number',
        "userId":              '#number',
        "planId":              '#number',
        "planName":            '#string',
        "status":              '#string',
        "startDate":           '#string',
        "monthlyRequestCount": '#number',
        "canMakeRequest":      '#boolean'
      }
      """
    And match response.userId == sub.userId

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}/active
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get active subscription by user id returns the active subscription
    * def sub = newSub()
    Given path '/subscriptions'
    And request sub
    When method POST
    Then status 201

    Given path '/subscriptions/users', sub.userId, 'active'
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                  '#number',
        "userId":              '#number',
        "planId":              '#number',
        "planName":            '#string',
        "status":              '#string',
        "startDate":           '#string',
        "monthlyRequestCount": '#number',
        "canMakeRequest":      '#boolean'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # PUT /subscriptions/users/{userId}/upgrade/{planId}
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @put
  Scenario: Upgrade subscription to a new plan returns 200
    # v3.3: upgrade 500s if the user has no subscription or the plan is unknown.
    * def sub = newSub()
    Given path '/subscriptions'
    And request sub
    When method POST
    Then status 201

    Given path '/subscriptions/users', sub.userId, 'upgrade', plan.planId
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @delete
  Scenario: Cancel subscription returns 204
    # v3.3: DELETE 500s if the user has no subscription. Ensure one exists first.
    * def sub = newSub()
    Given path '/subscriptions'
    And request sub
    When method POST
    Then status 201

    Given path '/subscriptions/users', sub.userId
    When method DELETE
    Then status 204
