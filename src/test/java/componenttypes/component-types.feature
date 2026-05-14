# componenttypes/component-types.feature
# ─────────────────────────────────────────────────────────────────
# Component Type Management Module — Integration tests.
# Base Path: /api/v1/component-types
#
# Endpoints covered:
#   - GET  /component-types
#   - POST /component-types
# ─────────────────────────────────────────────────────────────────

Feature: Component Type Management module - list and create

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /component-types — list every type
  # ────────────────────────────────────────────────────────────────
  @smoke @componenttypes @get
  Scenario: Get all component types returns the documented schema
    Given path '/component-types'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string'
      }
      """
    And assert response.length > 0

  # ────────────────────────────────────────────────────────────────
  # POST /component-types — create a new component type
  # ────────────────────────────────────────────────────────────────
  @regression @componenttypes @post
  Scenario: Create component type returns 201 with the created entity
    Given path '/component-types'
    And request testData.newComponentType
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string'
      }
      """
    And match response.name == 'Hydraulic'
    And match response.description == 'Hydraulic components'
