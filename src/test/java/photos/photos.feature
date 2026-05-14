# photos/photos.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Report Photos — Integration tests.
# Base Path: /api/v1/photos
#
# Endpoints covered:
#   - POST /photos
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Report Photos module - attach photo to report

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /photos — add a photo to a report
  # ────────────────────────────────────────────────────────────────
  @regression @photos @post
  Scenario: Add photo to report returns 201 with the created reference
    Given path '/photos'
    And request testData.newPhoto
    When method POST
    Then status 201
    And match response ==
      """
      {
        "reportId": '#number',
        "photoUrl": '#string'
      }
      """
    And match response.reportId == 1
    And match response.photoUrl == 'https://example.com/photos/photo1.jpg'
