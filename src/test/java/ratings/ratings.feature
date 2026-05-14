# ratings/ratings.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Ratings — Integration tests.
# Base Path: /api/v1/ratings
#
# Endpoints covered:
#   - POST   /ratings
#   - PUT    /ratings
#   - DELETE /ratings/{ratingId}
#   - GET    /ratings/{ratingId}
#   - GET    /ratings
#   - GET    /ratings/technicians/{technicianId}
#   - GET    /ratings/technicians/{technicianId}/featured
#   - GET    /ratings/requests/{requestId}
# ─────────────────────────────────────────────────────────────────

Feature: Monitoring Ratings module - rating lifecycle and queries

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /ratings — create a rating
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @post
  Scenario: Create rating returns 201 with the created rating
    Given path '/ratings'
    And request testData.newRating
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":           '#number',
        "score":        '#number',
        "comment":      '#string',
        "technicianId": '#number',
        "requestId":    '#number',
        "createdAt":    '#string'
      }
      """
    And match response.score == 5
    And match response.comment == 'Excellent service!'

  # ────────────────────────────────────────────────────────────────
  # PUT /ratings — update an existing rating (id in body)
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @put
  Scenario: Update rating returns 200
    Given path '/ratings'
    And request testData.updateRating
    When method PUT
    Then status 200

  # ────────────────────────────────────────────────────────────────
  # DELETE /ratings/{ratingId} — delete a rating
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @delete
  Scenario: Delete rating returns 204
    Given path '/ratings', 1
    When method DELETE
    Then status 204

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/{ratingId} — fetch a rating by id
  # ────────────────────────────────────────────────────────────────
  @smoke @ratings @get
  Scenario: Get rating by id returns the expected rating
    Given path '/ratings', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "score":        '#number',
        "comment":      '#string',
        "technicianId": '#number',
        "requestId":    '#number',
        "createdAt":    '#string'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # GET /ratings — list every rating
  # ────────────────────────────────────────────────────────────────
  @smoke @ratings @get
  Scenario: Get all ratings returns an array of ratings
    Given path '/ratings'
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/technicians/{technicianId}
  # ────────────────────────────────────────────────────────────────
  @smoke @ratings @get
  Scenario: Get ratings by technician returns the technician's ratings
    Given path '/ratings/technicians', 1
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { technicianId: 1 }

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/technicians/{technicianId}/featured
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @get
  Scenario: Get featured ratings by technician returns featured ratings
    Given path '/ratings/technicians', 1, 'featured'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { technicianId: 1, featured: true }

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/requests/{requestId}
  # ────────────────────────────────────────────────────────────────
  @smoke @ratings @get
  Scenario: Get ratings by request returns ratings tied to that request
    Given path '/ratings/requests', 1
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { requestId: 1 }
