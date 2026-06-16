# components/components.feature
# ─────────────────────────────────────────────────────────────────
# Component Management Module — Integration tests.
# Base Path: /api/v1/components
# ─────────────────────────────────────────────────────────────────

Feature: Component Management module - full CRUD

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def uniqueComponent = function(){ return karate.merge(testData.newComponent, { name: 'Component_' + java.util.UUID.randomUUID() }) }

  # ────────────────────────────────────────────────────────────────
  # GET /components — list every component
  # ────────────────────────────────────────────────────────────────
  @smoke @components @get
  Scenario: Get all components returns an array of components
    Given path '/components'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { id: '#string', name: '#string', description: '##string', isActive: '#boolean', componentTypeId: '#number' })

  # ────────────────────────────────────────────────────────────────
  # POST /components — create a new component
  # ────────────────────────────────────────────────────────────────
  @regression @components @post
  Scenario: Create component returns 201 with the created entity
    * def component = uniqueComponent()
    Given path '/components'
    And request component
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
    And match response.name == component.name
    And match response.componentTypeId == 1
    And match response.isActive == true

  # ────────────────────────────────────────────────────────────────
  # GET /components/{componentId} — fetch a component
  # ────────────────────────────────────────────────────────────────
  @smoke @components @get
  Scenario: Get component by id returns the expected payload
    # Create a component so we have a guaranteed id to look up
    * def component = uniqueComponent()
    Given path '/components'
    And request component
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/components', createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response.name == component.name

  # ────────────────────────────────────────────────────────────────
  # PUT /components/{componentId} — update an existing component
  # ────────────────────────────────────────────────────────────────
  @regression @components @put
  Scenario: Update component returns 200 with the updated entity
    * def component = uniqueComponent()
    Given path '/components'
    And request component
    When method POST
    Then status 201
    * def createdId = response.id

    * def updated = karate.merge(testData.updateComponent, { name: 'Updated_' + java.util.UUID.randomUUID() })
    Given path '/components', createdId
    And request updated
    When method PUT
    Then status 200
    And match response.id == createdId
    And match response.name == updated.name

  # ────────────────────────────────────────────────────────────────
  # DELETE /components/{componentId} — delete a component
  # ────────────────────────────────────────────────────────────────
  @regression @components @delete
  Scenario: Delete component returns 204
    # No stock references this component, so the FK delete guard (→500) is not hit.
    * def component = uniqueComponent()
    Given path '/components'
    And request component
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/components', createdId
    When method DELETE
    Then status 204
