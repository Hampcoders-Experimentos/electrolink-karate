# serviceoperations/service-operations.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Service Operations — Integration tests.
# Base Path: /api/v1/service-operations
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateServiceOperationResource = { requestId, technicianId }
#   ServiceOperationResource       = { id, requestId, technicianId,
#                                      startedAt, completedAt, currentStatus }
#   UpdateServiceStatusResource    = { serviceOperationId, newStatus }
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Service Operations module - operation lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /service-operations — create a service operation
  # ────────────────────────────────────────────────────────────────
  @regression @serviceoperations @post
  Scenario: Create service operation returns 201 with the created entity
    Given path '/service-operations'
    And request testData.newServiceOperation
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":            '#number',
        "requestId":     '#number',
        "technicianId":  '#number',
        "startedAt":     '##string',
        "completedAt":   '##string',
        "currentStatus": '#string'
      }
      """
    And match response.requestId == testData.newServiceOperation.requestId
    And match response.technicianId == testData.newServiceOperation.technicianId

  # ────────────────────────────────────────────────────────────────
  # GET /service-operations/{serviceOperationId}
  # ────────────────────────────────────────────────────────────────
  @smoke @serviceoperations @get
  Scenario: Get service operation by id returns the expected operation
    Given path '/service-operations'
    And request testData.newServiceOperation
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/service-operations', createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response ==
      """
      {
        "id":            '#number',
        "requestId":     '#number',
        "technicianId":  '#number',
        "startedAt":     '##string',
        "completedAt":   '##string',
        "currentStatus": '#string'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /service-operations/technicians/{technicianId}
  # ────────────────────────────────────────────────────────────────
  @smoke @serviceoperations @get
  Scenario: Get service operations by technician returns assignments
    Given path '/service-operations/technicians', testData.newServiceOperation.technicianId
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /service-operations — list every service operation
  # ────────────────────────────────────────────────────────────────
  @smoke @serviceoperations @get
  Scenario: Get all service operations returns an array
    Given path '/service-operations'
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # PUT /service-operations/status — update operation status
  # ────────────────────────────────────────────────────────────────
  @regression @serviceoperations @put
  Scenario: Update service operation status returns 204
    # Create a service operation so we have a valid id to update
    Given path '/service-operations'
    And request testData.newServiceOperation
    When method POST
    Then status 201
    * def createdId = response.id
    * def payload = { serviceOperationId: '#(createdId)', newStatus: 'COMPLETED' }

    Given path '/service-operations/status'
    And request payload
    When method PUT
    Then status 204
