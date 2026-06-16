# componenttypes/component-types.feature
# ─────────────────────────────────────────────────────────────────
# Component Type Management Module — Integration tests.
# Base Path: /api/v1/component-types
# ─────────────────────────────────────────────────────────────────

Feature: Component Type Management module - list and create

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /component-types — list every type
  # ────────────────────────────────────────────────────────────────
  @smoke @componenttypes @get
  Scenario: Get all component types returns the documented schema
    Given path '/component-types'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { componentTypeId: '#number', name: '#string', description: '##string' })

  # ────────────────────────────────────────────────────────────────
  # POST /component-types — create a new component type
  # ────────────────────────────────────────────────────────────────
  @regression @componenttypes @post
  Scenario: Create component type returns 201 with the created entity
    # Use a unique name so reruns don't collide
    * def randomSuffix = '' + Math.floor(Math.random() * 1000000000)
    * def uniqueName = 'Hydraulic_' + randomSuffix
    * def body = { name: '#(uniqueName)', description: 'Hydraulic components' }

    Given path '/component-types'
    And request body
    When method POST
    Then status 201
    And match response ==
      """
      {
        "componentTypeId": '#number',
        "name":            '#string',
        "description":     '##string'
      }
      """
    And match response.name == uniqueName
    And match response.description == 'Hydraulic components'
