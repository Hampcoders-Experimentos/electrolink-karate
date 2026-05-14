# schedules/schedules.feature
# ─────────────────────────────────────────────────────────────────
# Service Delivery Platform (SDP) - Schedules — Integration tests.
# Base Path: /api/v1
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateScheduleResource / UpdateScheduleResource
#     = { technicianId, day, startTime, endTime }
#   ScheduleResource = same fields + id
#
# POST /schedules returns the created Long id (raw number in body).
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
    Given path '/technicians', testData.newSchedule.technicianId, 'schedules'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":           '#number',
        "technicianId": '#string',
        "day":          '#string',
        "startTime":    '#string',
        "endTime":      '#string'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # POST /schedules — create a new schedule (returns Long id)
  # ────────────────────────────────────────────────────────────────
  @regression @schedules @post
  Scenario: Create schedule returns 200 with the created schedule id (Long)
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
    # Create a schedule first to obtain a valid id
    Given path '/schedules'
    And request testData.newSchedule
    When method POST
    Then status 200
    * def createdId = response

    Given path '/schedules', createdId
    And request testData.updateSchedule
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /schedules/{scheduleId} — delete a schedule
  # ────────────────────────────────────────────────────────────────
  @regression @schedules @delete
  Scenario: Delete schedule returns 200
    Given path '/schedules'
    And request testData.newSchedule
    When method POST
    Then status 200
    * def createdId = response

    Given path '/schedules', createdId
    When method DELETE
    Then status 200
