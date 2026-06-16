# reports/reports.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Reports — Integration tests.
# Base Path: /api/v1/reports
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Reports module - service report lifecycle

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def so = callonce read('classpath:common/seed-helper.feature@serviceOperation')
    * def report = karate.merge(testData.newReport, { serviceOperationId: so.soId })

  # ────────────────────────────────────────────────────────────────
  # POST /reports — create a report
  # ────────────────────────────────────────────────────────────────
  @regression @reports @post
  Scenario: Create report returns 201 with the created report
    Given path '/reports'
    And request report
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
    And request report
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
    And request report
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
    And match response == '#array'

  # ────────────────────────────────────────────────────────────────
  # GET /reports/requests/{serviceOperationId}
  # ────────────────────────────────────────────────────────────────
  @smoke @reports @get
  Scenario: Get reports by service operation returns matching reports
    Given path '/reports/requests', so.soId
    When method GET
    Then status 200
    And match response == '#array'
