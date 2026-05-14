# photos/photos.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Report Photos — Integration tests.
# Base Path: /api/v1/photos
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateReportPhotoResource = { reportId, photoData(byte[] as base64),
#                                 fileName, contentType }
#
# Note: the controller echoes the created CreateReportPhotoResource back
# in the response body.
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
  Scenario: Add photo to report returns 201 echoing the created resource
    Given path '/photos'
    And request testData.newPhoto
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
    And match response.reportId == testData.newPhoto.reportId
    And match response.fileName == 'photo.jpg'
    And match response.contentType == 'image/jpeg'
