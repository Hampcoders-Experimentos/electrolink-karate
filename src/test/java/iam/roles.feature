# roles/roles.feature
# ─────────────────────────────────────────────────────────────────
# Role Management Module — Integration tests.
# Base Path: /api/v1/roles
#
# Endpoints covered:
#   - GET /roles
#
# Real API contract (verified against the running backend):
#   • Response is an array of { id, name } — no description, no createdAt.
#   • The Roles enum exposes: ROLE_HOMEOWNER, ROLE_TECHNICIAN, ROLE_CLIENT.
# ─────────────────────────────────────────────────────────────────

Feature: Role Management module - list available roles

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }

  # ────────────────────────────────────────────────────────────────
  # GET /roles — list every system role
  # ────────────────────────────────────────────────────────────────
  @smoke @roles @get
  Scenario: Get all roles returns the three documented enum values
    Given path '/roles'
    When method GET
    Then status 200
    And match response == '#array'
    And match each response ==
      """
      {
        "id":   '#number',
        "name": '#string'
      }
      """
    And assert response.length >= 3
    * def names = karate.map(response, function(r){ return r.name })
    And match names contains 'ROLE_HOMEOWNER'
    And match names contains 'ROLE_TECHNICIAN'
    And match names contains 'ROLE_CLIENT'
