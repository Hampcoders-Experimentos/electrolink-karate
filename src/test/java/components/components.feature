# components/components.feature
# ─────────────────────────────────────────────────────────────────
# Component Management Module — Integration tests.
# Base Path: /api/v1/components
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateComponentResource = { name, description, componentTypeId, isActive }
#   UpdateComponentResource = same shape as Create
#   ComponentResource       = { id(string), name, description, isActive,
#                               componentTypeId }
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
        "id":              '#string',
        "name":            '#string',
        "description":     '##string',
        "isActive":        '#boolean',
        "componentTypeId": '#number'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # POST /components — create a new component
  # ────────────────────────────────────────────────────────────────
  @regression @components @post
  Scenario: Create component returns 201 with the created entity
    Given path '/components'
    And request testData.newComponent
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":              '#string',
        "name":            '#string',
        "description":     '##string',
        "isActive":        '#boolean',
        "componentTypeId": '#number'
      }
      """
    And match response.name == 'Circuit Breaker 32A'
    And match response.componentTypeId == 1
    And match response.isActive == true

  # ────────────────────────────────────────────────────────────────
  # GET /components/{componentId} — fetch a component
  # ────────────────────────────────────────────────────────────────
  @smoke @components @get
  Scenario: Get component by id returns the expected payload
    # Create a component so we have a guaranteed id to look up
    Given path '/components'
    And request testData.newComponent
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/components', createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response.name == testData.newComponent.name

  # ────────────────────────────────────────────────────────────────
  # PUT /components/{componentId} — update an existing component
  # ────────────────────────────────────────────────────────────────
  @regression @components @put
  Scenario: Update component returns 200 with the updated entity
    Given path '/components'
    And request testData.newComponent
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/components', createdId
    And request testData.updateComponent
    When method PUT
    Then status 200
    And match response.id == createdId
    And match response.name == 'Updated Breaker'

  # ────────────────────────────────────────────────────────────────
  # DELETE /components/{componentId} — delete a component
  # ────────────────────────────────────────────────────────────────
  @regression @components @delete
  Scenario: Delete component returns 204
    Given path '/components'
    And request testData.newComponent
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/components', createdId
    When method DELETE
    Then status 204
