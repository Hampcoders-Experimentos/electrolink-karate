# serviceoperations/service-operations.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Service Operations — Integration tests.
# Base Path: /api/v1/service-operations
#
# Endpoints covered:
#   - POST /service-operations
#   - GET  /service-operations/{serviceOperationId}
#   - GET  /service-operations/technicians/{technicianId}
#   - GET  /service-operations
#   - PUT  /service-operations/status
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
        "id":                '#number',
        "technicianId":      '#number',
        "serviceId":         '#number',
        "startTime":         '#string',
        "estimatedDuration": '#number',
        "status":            '#string',
        "createdAt":         '#string'
      }
      """
    And match response.technicianId == 1
    And match response.serviceId == 1
    And match response.status == 'IN_PROGRESS'

  # ────────────────────────────────────────────────────────────────
  # GET /service-operations/{serviceOperationId}
  # ────────────────────────────────────────────────────────────────
  @smoke @serviceoperations @get
  Scenario: Get service operation by id returns the expected operation
    Given path '/service-operations', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                '#number',
        "technicianId":      '#number',
        "serviceId":         '#number',
        "startTime":         '#string',
        "estimatedDuration": '#number',
        "status":            '#string',
        "createdAt":         '#string'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # GET /service-operations/technicians/{technicianId}
  # ────────────────────────────────────────────────────────────────
  @smoke @serviceoperations @get
  Scenario: Get service operations by technician returns assignments
    Given path '/service-operations/technicians', 1
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { technicianId: 1 }

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
    Given path '/service-operations/status'
    And request testData.updateServiceOperationStatus
    When method PUT
    Then status 204
