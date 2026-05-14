# ratings/ratings.feature
# ─────────────────────────────────────────────────────────────────
# Monitoring - Ratings — Integration tests.
# Base Path: /api/v1/ratings
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateRatingResource = { requestId, score, comment, raterId, technicianId }
#   UpdateRatingResource = { ratingId, score, comment }
#   RatingResource       = { id, requestId, score, comment, raterId, technicianId }
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
        "requestId":    '#number',
        "score":        '#number',
        "comment":      '#string',
        "raterId":      '#string',
        "technicianId": '#number'
      }
      """
    And match response.score == 5
    And match response.comment == 'Excellent service!'
    And match response.raterId == 'CLIENT001'

  # ────────────────────────────────────────────────────────────────
  # PUT /ratings — update an existing rating (id in body)
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @put
  Scenario: Update rating returns 200 (empty body)
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
    # Create a rating first so we have a guaranteed id
    Given path '/ratings'
    And request testData.newRating
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/ratings', createdId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "requestId":    '#number',
        "score":        '#number',
        "comment":      '#string',
        "raterId":      '#string',
        "technicianId": '#number'
      }
      """
    And match response.id == createdId

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
    Given path '/ratings/technicians', testData.newRating.technicianId
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/technicians/{technicianId}/featured
  # ────────────────────────────────────────────────────────────────
  @regression @ratings @get
  Scenario: Get featured ratings by technician returns featured ratings
    Given path '/ratings/technicians', testData.newRating.technicianId, 'featured'
    When method GET
    Then status 200
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /ratings/requests/{requestId}
  # ────────────────────────────────────────────────────────────────
  @smoke @ratings @get
  Scenario: Get ratings by request returns ratings tied to that request
    Given path '/ratings/requests', testData.newRating.requestId
    When method GET
    Then status 200
    And match response == '#[] #object'
