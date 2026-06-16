# photos/photos.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Report Photos — Integration tests.
# Base Path: /api/v1/photos
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Report Photos module - attach photo to report

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def seed = callonce read('classpath:common/seed-helper.feature@report')
    * def photo = karate.merge(testData.newPhoto, { reportId: seed.reportId })

  # ────────────────────────────────────────────────────────────────
  # POST /photos — add a photo to a report
  # ────────────────────────────────────────────────────────────────
  @regression @photos @post
  Scenario: Add photo to report returns 201 echoing the created resource
    Given path '/photos'
    And request photo
    When method POST
    Then status 201
    And match response contains
      """
      {
        "reportId":    '#number',
        "fileName":    '#string',
        "contentType": '#string'
      }
      """
    And match response.reportId == seed.reportId
    And match response.fileName == 'photo.jpg'
    And match response.contentType == 'image/jpeg'
