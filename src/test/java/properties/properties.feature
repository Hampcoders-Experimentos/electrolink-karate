# properties/properties.feature
# ─────────────────────────────────────────────────────────────────
# Property Management Module — Integration tests.
# Base Path: /api/v1/properties
#
# Endpoints covered:
#   - GET    /properties
#   - GET    /properties/owner/{ownerId}
#   - GET    /properties/{propertyId}
#   - POST   /properties
#   - PUT    /properties/{propertyId}
#   - DELETE /properties/{propertyId}
# ─────────────────────────────────────────────────────────────────

Feature: Property Management module - full CRUD

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')
    * def samplePropertyId = '550e8400-e29b-41d4-a716-446655440000'

  # ────────────────────────────────────────────────────────────────
  # GET /properties — list every property
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get all properties returns a list of property objects
    Given path '/properties'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":        '#uuid',
        "address":   '#string',
        "city":      '#string',
        "state":     '#string',
        "zipCode":   '#string',
        "ownerId":   '#number',
        "createdAt": '#string'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /properties/owner/{ownerId} — list by owner
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get properties by owner id returns the owner's properties
    Given path '/properties/owner', 1
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response contains { ownerId: 1 }

  # ────────────────────────────────────────────────────────────────
  # GET /properties/{propertyId} — fetch a property by UUID
  # ────────────────────────────────────────────────────────────────
  @smoke @properties @get
  Scenario: Get property by id returns the expected payload
    Given path '/properties', samplePropertyId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":        '#uuid',
        "address":   '#string',
        "city":      '#string',
        "state":     '#string',
        "zipCode":   '#string',
        "ownerId":   '#number',
        "createdAt": '#string'
      }
      """
    And match response.id == samplePropertyId

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
        "id":        '#uuid',
        "address":   '#string',
        "city":      '#string',
        "state":     '#string',
        "zipCode":   '#string',
        "ownerId":   '#number',
        "createdAt": '#string'
      }
      """
    And match response.address == '456 Oak Ave'
    And match response.city == 'Los Angeles'
    And match response.state == 'CA'
    And match response.zipCode == '90001'
    And match response.ownerId == 1

  # ────────────────────────────────────────────────────────────────
  # PUT /properties/{propertyId} — update an existing property
  # ────────────────────────────────────────────────────────────────
  @regression @properties @put
  Scenario: Update property returns 200 with the updated property
    Given path '/properties', samplePropertyId
    And request testData.updateProperty
    When method PUT
    Then status 200
    And match response.address == '789 Elm St'
    And match response.city == 'Chicago'
    And match response.state == 'IL'
    And match response.zipCode == '60601'

  # ────────────────────────────────────────────────────────────────
  # DELETE /properties/{propertyId} — remove a property
  # ────────────────────────────────────────────────────────────────
  @regression @properties @delete
  Scenario: Delete property returns 204
    Given path '/properties', samplePropertyId
    When method DELETE
    Then status 204
