# analytics/analytics.feature
# ─────────────────────────────────────────────────────────────────
# Analytics Module — Integration tests.
# Base Path: /api/v1/analytics
#
# DTOs (per ELECTROLINK_API_ENDPOINTS.md v2.0):
#   HomeOwnerConsumptionResource = { ownerId, month, year,
#                                    energyConsumed, amountPaid,
#                                    serviceRequestsCount }
#   TechnicianPerformanceResource = { technicianId, totalServicesCompleted,
#                                     averageRating, averageCompletionTimeHours,
#                                     pendingServices }
#   TechnicianRevenueResource     = { technicianId, period, totalRevenue,
#                                     servicesCount, averageRevenuePerService }
# ─────────────────────────────────────────────────────────────────

Feature: Analytics module - homeowner and technician metrics

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken

  # ────────────────────────────────────────────────────────────────
  # GET /analytics/homeowners/{ownerId}/consumption?months=12
  # ────────────────────────────────────────────────────────────────
  @smoke @analytics @get
  Scenario: Get home owner consumption returns monthly consumption data
    Given path '/analytics/homeowners', 1, 'consumption'
    And param months = 12
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "ownerId":              '#number',
        "month":                '#number',
        "year":                 '#number',
        "energyConsumed":       '#number',
        "amountPaid":           '#number',
        "serviceRequestsCount": '#number'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /analytics/technicians/{technicianId}/performance
  # ────────────────────────────────────────────────────────────────
  @smoke @analytics @get
  Scenario: Get technician performance returns performance metrics
    Given path '/analytics/technicians', 1, 'performance'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "technicianId":               '#number',
        "totalServicesCompleted":     '#number',
        "averageRating":              '#number',
        "averageCompletionTimeHours": '#number',
        "pendingServices":            '#number'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /analytics/technicians/{technicianId}/revenue?months=6
  # ────────────────────────────────────────────────────────────────
  @smoke @analytics @get
  Scenario: Get technician revenue returns revenue data
    Given path '/analytics/technicians', 1, 'revenue'
    And param months = 6
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "technicianId":             '#number',
        "period":                   '#string',
        "totalRevenue":             '#number',
        "servicesCount":            '#number',
        "averageRevenuePerService": '#number'
      }
      """
