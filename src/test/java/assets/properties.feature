# properties/properties.feature
# ─────────────────────────────────────────────────────────────────
# Property Management Module — Integration tests.
# Base Path: /api/v1/properties
# ─────────────────────────────────────────────────────────────────

Feature: Property Management module - full CRUD

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /properties — list every property
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get all properties returns a list of property objects
    Given path '/properties'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { id: '#string', ownerId: '#string', address: '#object', region: '#object', district: '#object' })

  # ────────────────────────────────────────────────────────────────
  # POST /properties — create a new property
  # ────────────────────────────────────────────────────────────────
  @regression @properties @post
  Scenario: Create property returns 201 with the created property
    Given path '/properties'
    And request testData.newProperty
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":       '#string',
        "ownerId":  '#string',
        "address":  '#object',
        "region":   '#object',
        "district": '#object'
      }
      """
    And match response.address.street == 'Av. Javier Prado'
    And match response.address.city == 'Lima'
    And match response.address.country == 'PE'

  # ────────────────────────────────────────────────────────────────
  # GET /properties/owner/{ownerId} — list by owner
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get properties by owner id returns the owner's properties
    Given path '/properties/owner', testData.newProperty.ownerId
    When method GET
    Then status 200
    And match response == '#array'

  # ────────────────────────────────────────────────────────────────
  # GET /properties/{propertyId} — fetch a property by id
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get property by id returns the expected payload
    Given path '/properties'
    And request testData.newProperty
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/properties', createdId
    When method GET
    Then status 200
    And match response.id == createdId

  # ────────────────────────────────────────────────────────────────
  # PUT /properties/{propertyId} — update an existing property
  # ────────────────────────────────────────────────────────────────
  @regression @properties @put
  Scenario: Update property returns 200 with the updated property
    Given path '/properties'
    And request testData.newProperty
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/properties', createdId
    And request testData.updateProperty
    When method PUT
    Then status 200
    And match response.id == createdId
    And match response.address.street == 'Av. La Marina'

  # ────────────────────────────────────────────────────────────────
  # DELETE /properties/{propertyId} — remove a property
  # ────────────────────────────────────────────────────────────────
  @regression @properties @delete
  Scenario: Delete property returns 204
    Given path '/properties'
    And request testData.newProperty
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/properties', createdId
    When method DELETE
    Then status 204
