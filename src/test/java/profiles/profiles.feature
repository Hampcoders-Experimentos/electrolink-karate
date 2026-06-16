# profiles/profiles.feature
# ─────────────────────────────────────────────────────────────────
# Profile Management Module — Integration tests.
# Base Path: /api/v1/profiles
# ─────────────────────────────────────────────────────────────────

Feature: Profile Management module - full CRUD plus search

  Background:
    * url baseUrl
    * def testData = read('classpath:common/test-data.json')
    * def uniqueProfile = function(){ return karate.merge(testData.newProfile, { email: 'profile_' + java.util.UUID.randomUUID() + '@example.com' }) }

  # ────────────────────────────────────────────────────────────────
  # POST /profiles — create a new profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @post
  Scenario: Create profile returns 201 with the created profile
    * def profile = uniqueProfile()
    Given path '/profiles'
    And request profile
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":                            '#number',
        "firstName":                     '#string',
        "lastName":                      '#string',
        "email":                         '#regex .+@.+',
        "street":                        '#string',
        "role":                          '#string',
        "additionalInfoOrCertification": '#string',
        "isVerified":                    '#boolean'
      }
      """
    And match response.firstName == 'John'
    And match response.lastName == 'Doe'
    And match response.email == profile.email
    And match response.role == 'TECHNICIAN'

  # ────────────────────────────────────────────────────────────────
  # GET /profiles — list every profile
  # ────────────────────────────────────────────────────────────────
  @smoke @profiles @get
  Scenario: Get all profiles returns an array of profiles
    Given path '/profiles'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { id: '#number', firstName: '#string', lastName: '#string', email: '#regex .+@.+', street: '#string', role: '#string', additionalInfoOrCertification: '##string', isVerified: '#boolean' })

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/{profileId} — fetch a profile
  # ────────────────────────────────────────────────────────────────
  @smoke @profiles @get
  Scenario: Get profile by id returns the expected profile
    # Create a profile so we have a guaranteed id to look up
    * def profile = uniqueProfile()
    Given path '/profiles'
    And request profile
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/profiles', createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response.firstName == profile.firstName

  # ────────────────────────────────────────────────────────────────
  # PUT /profiles/{profileId} — update a profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @put
  Scenario: Update profile returns 200 with the updated profile
    * def profile = uniqueProfile()
    Given path '/profiles'
    And request profile
    When method POST
    Then status 201
    * def createdId = response.id

    # v3.3: PUT also 500s if the new email is already used by another profile.
    * def updated = karate.merge(testData.updateProfile, { email: 'updated_' + java.util.UUID.randomUUID() + '@example.com' })
    Given path '/profiles', createdId
    And request updated
    When method PUT
    Then status 200
    And match response.firstName == 'Jane'
    And match response.lastName == 'Smith'
    And match response.email == updated.email

  # ────────────────────────────────────────────────────────────────
  # DELETE /profiles/{profileId} — delete a profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @delete
  Scenario: Delete profile returns 204
    * def profile = uniqueProfile()
    Given path '/profiles'
    And request profile
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/profiles', createdId
    When method DELETE
    Then status 204

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/search?email=...
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @get @search
  Scenario: Search profiles by email returns matching profiles
    Given path '/profiles/search'
    And param email = 'john.doe@example.com'
    When method GET
    Then status 200
    And match response == '#array'

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/search?role=...
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @get @search
  Scenario: Search profiles by role returns matching profiles
    Given path '/profiles/search'
    And param role = 'TECHNICIAN'
    When method GET
    Then status 200
    And match response == '#array'

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/search?firstName=...&lastName=...
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @get @search
  Scenario: Search profiles by full name returns matching profiles
    Given path '/profiles/search'
    And param firstName = 'John'
    And param lastName = 'Doe'
    When method GET
    Then status 200
    And match response == '#array'
