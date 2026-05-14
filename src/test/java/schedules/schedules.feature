# schedules/schedules.feature
# ─────────────────────────────────────────────────────────────────
# Service Delivery Platform (SDP) - Schedules — Integration tests.
# Base Path: /api/v1
#
# Endpoints covered:
#   - GET    /technicians/{technicianId}/schedules
#   - POST   /schedules
#   - PUT    /schedules/{scheduleId}
#   - DELETE /schedules/{scheduleId}
# ─────────────────────────────────────────────────────────────────

Feature: SDP Schedules module - technician scheduling

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /technicians/{technicianId}/schedules
  # ────────────────────────────────────────────────────────────────
  @smoke @schedules @get
  Scenario: Get schedules by technician returns the technician's schedules
    Given path '/technicians', 'TECH001', 'schedules'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":           '#number',
        "technicianId": '#string',
        "scheduleDate": '#string',
        "status":       '#string',
        "tasks":        '#number'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # POST /schedules — create a new schedule
  # ────────────────────────────────────────────────────────────────
  @regression @schedules @post
  Scenario: Create schedule returns 200 with the created schedule id
    Given path '/schedules'
    And request testData.newSchedule
    When method POST
    Then status 200
    And match response == '#number'

  # ────────────────────────────────────────────────────────────────
  # PUT /schedules/{scheduleId} — update an existing schedule
  # ────────────────────────────────────────────────────────────────
  @regression @schedules @put
  Scenario: Update schedule returns 200
    Given path '/schedules', 1
    And request testData.updateSchedule
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /schedules/{scheduleId} — delete a schedule
  # ────────────────────────────────────────────────────────────────
  @regression @schedules @delete
  Scenario: Delete schedule returns 200
    Given path '/schedules', 1
    When method DELETE
    Then status 200
