# subscriptions/subscriptions.feature
# ─────────────────────────────────────────────────────────────────
# Subscription Management Module — Integration tests.
# Base Path: /api/v1/subscriptions
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateSubscriptionResource = { userId, planId }
#   SubscriptionResource       = { id, userId, planId, planName, status,
#                                  startDate, monthlyRequestCount, canMakeRequest }
# ─────────────────────────────────────────────────────────────────

Feature: Subscription Management module - user subscription lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /subscriptions — create a subscription
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @post
  Scenario: Create subscription returns 201 with the new subscription
    Given path '/subscriptions'
    And request testData.newSubscription
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
    And match response.userId == testData.newSubscription.userId
    And match response.planId == testData.newSubscription.planId

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get subscription by user id returns the user's subscription
    Given path '/subscriptions/users', testData.newSubscription.userId
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
    And match response.userId == testData.newSubscription.userId

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}/active
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get active subscription by user id returns the active subscription
    Given path '/subscriptions/users', testData.newSubscription.userId, 'active'
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
    Given path '/subscriptions/users', testData.newSubscription.userId, 'upgrade', 2
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @delete
  Scenario: Cancel subscription returns 204
    Given path '/subscriptions/users', testData.newSubscription.userId
    When method DELETE
    Then status 204
