# services/services.feature
# ─────────────────────────────────────────────────────────────────
# Service Delivery Platform (SDP) - Services — Integration tests.
# Base Path: /api/v1/services
#
# Endpoints covered:
#   - GET    /services
#   - POST   /services
#   - PUT    /services/{serviceId}
#   - DELETE /services/{serviceId}
#   - GET    /services/{serviceId}
# ─────────────────────────────────────────────────────────────────

Feature: SDP Services module - service catalog CRUD

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /services — list every service
  # ────────────────────────────────────────────────────────────────
  @smoke @services @get
  Scenario: Get all services returns an array of services
    Given path '/services'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string',
        "price":       '#number',
        "duration":    '#number',
        "createdAt":   '#string'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # POST /services — create a new service
  # ────────────────────────────────────────────────────────────────
  @regression @services @post
  Scenario: Create service returns 201 with the created service
    Given path '/services'
    And request testData.newService
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string',
        "price":       '#number',
        "duration":    '#number',
        "createdAt":   '#string'
      }
      """
    And match response.name == 'New Service'
    And match response.price == 200.00
    And match response.duration == 90

  # ────────────────────────────────────────────────────────────────
  # PUT /services/{serviceId} — update an existing service
  # ────────────────────────────────────────────────────────────────
  @regression @services @put
  Scenario: Update service returns 200
    Given path '/services', 1
    And request testData.updateService
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /services/{serviceId} — delete a service
  # ────────────────────────────────────────────────────────────────
  @regression @services @delete
  Scenario: Delete service returns 200
    Given path '/services', 1
    When method DELETE
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # GET /services/{serviceId} — fetch a service by id
  # ────────────────────────────────────────────────────────────────
  @smoke @services @get
  Scenario: Get service by id returns the expected service
    Given path '/services', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string',
        "price":       '#number',
        "duration":    '#number',
        "createdAt":   '#string'
      }
      """
    And match response.id == 1
