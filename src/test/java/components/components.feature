# components/components.feature
# ─────────────────────────────────────────────────────────────────
# Component Management Module — Integration tests.
# Base Path: /api/v1/components
#
# Endpoints covered:
#   - GET    /components
#   - GET    /components/{componentId}
#   - POST   /components
#   - PUT    /components/{componentId}
#   - DELETE /components/{componentId}
# ─────────────────────────────────────────────────────────────────

Feature: Component Management module - full CRUD

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /components — list every component
  # ────────────────────────────────────────────────────────────────
  @smoke @components @get
  Scenario: Get all components returns an array of components
    Given path '/components'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":              '#number',
        "name":            '#string',
        "componentTypeId": '#number',
        "createdAt":       '#string'
      }
      """
    And assert response.length > 0

  # ────────────────────────────────────────────────────────────────
  # GET /components/{componentId} — fetch a component
  # ────────────────────────────────────────────────────────────────
  @smoke @components @get
  Scenario: Get component by id returns the expected payload
    Given path '/components', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":              '#number',
        "name":            '#string',
        "componentTypeId": '#number',
        "createdAt":       '#string'
      }
      """
    And match response.id == 1

  # ────────────────────────────────────────────────────────────────
  # GET /components/{componentId} — non-existent id returns 404
  # ────────────────────────────────────────────────────────────────
  @regression @components @get @negative
  Scenario: Get component by unknown id returns 404
    Given path '/components', 999999
    When method GET
    Then status 404

  # ────────────────────────────────────────────────────────────────
  # POST /components — create a new component
  # ────────────────────────────────────────────────────────────────
  @regression @components @post
  Scenario: Create component returns 201 and the created entity
    Given path '/components'
    And request testData.newComponent
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":              '#number',
        "name":            '#string',
        "componentTypeId": '#number',
        "createdAt":       '#string'
      }
      """
    And match response.name == 'New Breaker'
    And match response.componentTypeId == 1

  # ────────────────────────────────────────────────────────────────
  # PUT /components/{componentId} — update an existing component
  # ────────────────────────────────────────────────────────────────
  @regression @components @put
  Scenario: Update component returns 200 with the updated entity
    Given path '/components', 1
    And request testData.updateComponent
    When method PUT
    Then status 200
    And match response ==
      """
      {
        "id":              '#number',
        "name":            '#string',
        "componentTypeId": '#number',
        "createdAt":       '#string'
      }
      """
    And match response.name == 'Updated Breaker'

  # ────────────────────────────────────────────────────────────────
  # DELETE /components/{componentId} — delete a component
  # ────────────────────────────────────────────────────────────────
  @regression @components @delete
  Scenario: Delete component returns 204
    Given path '/components', 1
    When method DELETE
    Then status 204
