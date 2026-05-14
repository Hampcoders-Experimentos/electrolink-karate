# subscriptions/subscriptions.feature
# ─────────────────────────────────────────────────────────────────
# Subscription Management Module — Integration tests.
# Base Path: /api/v1/subscriptions
#
# Endpoints covered:
#   - POST   /subscriptions
#   - GET    /subscriptions/users/{userId}
#   - GET    /subscriptions/users/{userId}/active
#   - PUT    /subscriptions/users/{userId}/upgrade/{planId}
#   - DELETE /subscriptions/users/{userId}
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
        "id":              '#number',
        "userId":          '#number',
        "planId":          '#number',
        "status":          '#string',
        "startDate":       '#string',
        "nextBillingDate": '#string',
        "createdAt":       '#string'
      }
      """
    And match response.userId == 1
    And match response.planId == 1
    And match response.status == 'ACTIVE'

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get subscription by user id returns the user's subscription
    Given path '/subscriptions/users', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":              '#number',
        "userId":          '#number',
        "planId":          '#number',
        "status":          '#string',
        "startDate":       '#string',
        "nextBillingDate": '#string',
        "createdAt":       '#string'
      }
      """
    And match response.userId == 1

  # ────────────────────────────────────────────────────────────────
  # GET /subscriptions/users/{userId}/active
  # ────────────────────────────────────────────────────────────────
  @smoke @subscriptions @get
  Scenario: Get active subscription by user id returns the active subscription
    Given path '/subscriptions/users', 1, 'active'
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":              '#number',
        "userId":          '#number',
        "planId":          '#number',
        "status":          '#string',
        "startDate":       '#string',
        "nextBillingDate": '#string',
        "createdAt":       '#string'
      }
      """
    And match response.status == 'ACTIVE'

  # ────────────────────────────────────────────────────────────────
  # PUT /subscriptions/users/{userId}/upgrade/{planId}
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @put
  Scenario: Upgrade subscription to a new plan returns 200
    Given path '/subscriptions/users', 1, 'upgrade', 2
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /subscriptions/users/{userId}
  # ────────────────────────────────────────────────────────────────
  @regression @subscriptions @delete
  Scenario: Cancel subscription returns 204
    Given path '/subscriptions/users', 1
    When method DELETE
    Then status 204
