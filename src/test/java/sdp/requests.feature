# requests/requests.feature
# ─────────────────────────────────────────────────────────────────
# Service Delivery Platform (SDP) - Requests — Integration tests.
# Base Path: /api/v1/requests
# ─────────────────────────────────────────────────────────────────

Feature: SDP Requests module - full request lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def clientSub = callonce read('classpath:common/seed-helper.feature@clientSubscription')
    * def extractId = function(msg){ return msg.replace(/[^0-9]/g, '') }

  # ────────────────────────────────────────────────────────────────
  # POST /requests — create a new service request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @post
  Scenario: Create request returns 201 with a MessageResource
    Given path '/requests'
    And request testData.newRequest
    When method POST
    Then status 201
    And match response == { message: '#string' }

  # ────────────────────────────────────────────────────────────────
  # GET /requests/{id} — fetch a request
  # ────────────────────────────────────────────────────────────────
  @smoke @requests @get
  Scenario: Get request by id returns the request payload
    Given path '/requests'
    And request testData.newRequest
    When method POST
    Then status 201
    * def createdId = extractId(response.message)

    Given path '/requests', createdId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                 '#number',
        "clientId":           '#string',
        "technicianId":       '##string',
        "propertyId":         '#string',
        "serviceId":          '#string',
        "problemDescription": '#string',
        "scheduledDate":      '#string',
        "isPriority":         '#boolean',
        "bill":               '##object',
        "photos":             '##array'
      }
      """
    And match response.clientId == testData.newRequest.clientId

  # ────────────────────────────────────────────────────────────────
  # GET /requests/clients/{clientId}/requests
  # ────────────────────────────────────────────────────────────────
  @smoke @requests @get
  Scenario: Get requests by client returns the client's requests
    Given path '/requests/clients', testData.newRequest.clientId, 'requests'
    When method GET
    Then status 200
    And match response == '#array'

  # ────────────────────────────────────────────────────────────────
  # PUT /requests/{id} — update an existing request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @put
  Scenario: Update request returns 200 with a MessageResource
    Given path '/requests'
    And request testData.newRequest
    When method POST
    Then status 201
    * def createdId = extractId(response.message)

    Given path '/requests', createdId
    And request testData.updateRequest
    When method PUT
    Then status 200
    And match response == { message: '#string' }

  # ────────────────────────────────────────────────────────────────
  # DELETE /requests/{id} — delete a request
  # ────────────────────────────────────────────────────────────────
  @regression @requests @delete
  Scenario: Delete request returns 200 with a MessageResource
    Given path '/requests'
    And request testData.newRequest
    When method POST
    Then status 201
    * def createdId = extractId(response.message)

    Given path '/requests', createdId
    When method DELETE
    Then status 200
    And match response == { message: '#string' }
