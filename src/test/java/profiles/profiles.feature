# profiles/profiles.feature
# ─────────────────────────────────────────────────────────────────
# Profile Management Module — Integration tests.
# Base Path: /api/v1/profiles
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   CreateProfileResource = { firstName, lastName, email, street,
#                             role(HOMEOWNER|TECHNICIAN),
#                             additionalInfoOrCertification }
#   ProfileResource       = CreateProfileResource + { id, isVerified }
# ─────────────────────────────────────────────────────────────────

Feature: Profile Management module - full CRUD plus search

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # POST /profiles — create a new profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @post
  Scenario: Create profile returns 201 with the created profile
    Given path '/profiles'
    And request testData.newProfile
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
    And match response.email == 'john.doe@example.com'
    And match response.role == 'TECHNICIAN'

  # ────────────────────────────────────────────────────────────────
  # GET /profiles — list every profile
  # ────────────────────────────────────────────────────────────────
  @smoke @profiles @get
  Scenario: Get all profiles returns an array of profiles
    Given path '/profiles'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":                            '#number',
        "firstName":                     '#string',
        "lastName":                      '#string',
        "email":                         '#regex .+@.+',
        "street":                        '#string',
        "role":                          '#string',
        "additionalInfoOrCertification": '##string',
        "isVerified":                    '#boolean'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/{profileId} — fetch a profile
  # ────────────────────────────────────────────────────────────────
  @smoke @profiles @get
  Scenario: Get profile by id returns the expected profile
    # Create a profile so we have a guaranteed id to look up
    Given path '/profiles'
    And request testData.newProfile
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/profiles', createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response.firstName == testData.newProfile.firstName

  # ────────────────────────────────────────────────────────────────
  # PUT /profiles/{profileId} — update a profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @put
  Scenario: Update profile returns 200 with the updated profile
    Given path '/profiles'
    And request testData.newProfile
    When method POST
    Then status 201
    * def createdId = response.id

    Given path '/profiles', createdId
    And request testData.updateProfile
    When method PUT
    Then status 200
    And match response.firstName == 'Jane'
    And match response.lastName == 'Smith'
    And match response.email == 'jane.smith@example.com'

  # ────────────────────────────────────────────────────────────────
  # DELETE /profiles/{profileId} — delete a profile
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @delete
  Scenario: Delete profile returns 204
    Given path '/profiles'
    And request testData.newProfile
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
    And match response == '#[] #object'

  # ────────────────────────────────────────────────────────────────
  # GET /profiles/search?role=...
  # ────────────────────────────────────────────────────────────────
  @regression @profiles @get @search
  Scenario: Search profiles by role returns matching profiles
    Given path '/profiles/search'
    And param role = 'TECHNICIAN'
    When method GET
    Then status 200
    And match response == '#[] #object'

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
    And match response == '#[] #object'
