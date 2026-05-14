# roles/roles.feature
# ─────────────────────────────────────────────────────────────────
# Role Management Module — Integration tests.
# Base Path: /api/v1/roles
#
# Endpoints covered:
#   - GET /roles
# ─────────────────────────────────────────────────────────────────

Feature: Role Management module - list available roles

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken

  # ────────────────────────────────────────────────────────────────
  # GET /roles — list every system role
  # ────────────────────────────────────────────────────────────────
  @smoke @roles @get
  Scenario: Get all roles returns at least ADMIN, TECHNICIAN and HOME_OWNER
    Given path '/roles'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":          '#number',
        "name":        '#string',
        "description": '#string',
        "createdAt":   '#string'
      }
      """
    And assert response.length >= 3
    * def names = karate.map(response, function(r){ return r.name })
    And match names contains 'ADMIN'
    And match names contains 'TECHNICIAN'
    And match names contains 'HOME_OWNER'
