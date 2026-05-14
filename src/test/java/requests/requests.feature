# requests/requests.feature
# ─────────────────────────────────────────────────────────────────
# Service Delivery Platform (SDP) - Requests — Integration tests.
# Base Path: /api/v1/requests
#
# Endpoints covered:
#   - POST   /requests
#   - GET    /requests/{id}
#   - GET    /requests/clients/{clientId}/requests
#   - PUT    /requests/{id}
#   - DELETE /requests/{id}
# ─────────────────────────────────────────────────────────────────

Feature: SDP Requests module - full request lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /requests — create a new service request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @post
  Scenario: Create request returns 201 with the created request id message
    Given path '/requests'
    And request testData.newRequest
    When method POST
    Then status 201
    And match response.message == '#string'
    And match response.message contains 'Request created with ID:'

  # ────────────────────────────────────────────────────────────────
  # GET /requests/{id} — fetch a request
  # ────────────────────────────────────────────────────────────────
  @smoke @requests @get
  Scenario: Get request by id returns the request payload
    Given path '/requests', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":            '#number',
        "clientId":      '#string',
        "description":   '#string',
        "propertyId":    '#uuid',
        "preferredDate": '#string',
        "priority":      '#string',
        "status":        '#string',
        "createdAt":     '#string'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # GET /requests/clients/{clientId}/requests
  # ────────────────────────────────────────────────────────────────
  @smoke @requests @get
  Scenario: Get requests by client returns the client's requests
    Given path '/requests/clients', 'CLIENT001', 'requests'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { clientId: 'CLIENT001' }

  # ────────────────────────────────────────────────────────────────
  # PUT /requests/{id} — update an existing request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @put
  Scenario: Update request returns 200 with confirmation message
    Given path '/requests', 1
    And request testData.updateRequest
    When method PUT
    Then status 200
    And match response.message == 'Request updated successfully.'

  # ────────────────────────────────────────────────────────────────
  # DELETE /requests/{id} — delete a request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @delete
  Scenario: Delete request returns 200 with confirmation message
    Given path '/requests', 1
    When method DELETE
    Then status 200
    And match response.message == 'Request deleted successfully.'
