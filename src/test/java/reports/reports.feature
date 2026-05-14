# reports/reports.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Reports — Integration tests.
# Base Path: /api/v1/reports
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateReportResource = { serviceOperationId, reportType, description }
#   ReportResource       = { id, serviceOperationId, description, reportType }
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Reports module - service report lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /reports — create a report
  # ────────────────────────────────────────────────────────────────
  @regression @reports @post
  Scenario: Create report returns 201 with the created report
    Given path '/reports'
    And request testData.newReport
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":                 '#number',
        "serviceOperationId": '#number',
        "description":        '#string',
        "reportType":         '#string'
      }
      """
    And match response.reportType == 'INCIDENT'
    And match response.description == 'Inspection completed with minor findings'

  # ────────────────────────────────────────────────────────────────
  # DELETE /reports/{reportId} — delete a report
  # ────────────────────────────────────────────────────────────────
  @regression @reports @delete
  Scenario: Delete report returns 204
    # Create a report first so we have a guaranteed id
    Given path '/reports'
    And request testData.newReport
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/reports', createdId
    When method DELETE
    Then status 204

  # ────────────────────────────────────────────────────────────────
  # GET /reports/{reportId} — fetch a report
  # ────────────────────────────────────────────────────────────────
  @smoke @reports @get
  Scenario: Get report by id returns the expected report
    Given path '/reports'
    And request testData.newReport
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/reports', createdId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                 '#number',
        "serviceOperationId": '#number',
        "description":        '#string',
        "reportType":         '#string'
      }
      """
    And match response.id == createdId

  # ────────────────────────────────────────────────────────────────
  # GET /reports — list every report
  # ────────────────────────────────────────────────────────────────
  @smoke @reports @get
  Scenario: Get all reports returns an array of reports
    Given path '/reports'
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /reports/requests/{serviceOperationId}
  # ────────────────────────────────────────────────────────────────
  @smoke @reports @get
  Scenario: Get reports by service operation returns matching reports
    Given path '/reports/requests', testData.newReport.serviceOperationId
    When method GET
    Then status 200
    And match response == '#[] #object'
