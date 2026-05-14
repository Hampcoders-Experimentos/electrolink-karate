# reports/reports.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Reports — Integration tests.
# Base Path: /api/v1/reports
#
# Endpoints covered:
#   - POST   /reports
#   - DELETE /reports/{reportId}
#   - GET    /reports/{reportId}
#   - GET    /reports
#   - GET    /reports/requests/{serviceOperationId}
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
        "summary":            '#string',
        "findings":           '#string',
        "recommendations":    '#string',
        "createdAt":          '#string'
      }
      """
    And match response.summary == 'Inspection completed'
    And match response.findings == 'All systems operational'

  # ────────────────────────────────────────────────────────────────
  # DELETE /reports/{reportId} — delete a report
  # ────────────────────────────────────────────────────────────────
  @regression @reports @delete
  Scenario: Delete report returns 204
    Given path '/reports', 1
    When method DELETE
    Then status 204

  # ────────────────────────────────────────────────────────────────
  # GET /reports/{reportId} — fetch a report
  # ────────────────────────────────────────────────────────────────
  @smoke @reports @get
  Scenario: Get report by id returns the expected report
    Given path '/reports', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":                 '#number',
        "serviceOperationId": '#number',
        "summary":            '#string',
        "findings":           '#string',
        "recommendations":    '#string',
        "createdAt":          '#string'
      }
      """
    And match response.id == 1

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
    Given path '/reports/requests', 1
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { serviceOperationId: 1 }
