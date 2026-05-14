# technicianinventories/technician-inventories.feature
# ─────────────────────────────────────────────────────────────────
# Technician Inventory Module — Integration tests.
# Base Path: /api/v1/technician-inventories
#
# Endpoints covered:
#   - GET    /technician-inventories/low-stock
#   - GET    /technician-inventories/technician/{technicianId}/stocks/{componentId}
#   - GET    /technician-inventories/technician/{technicianId}
#   - POST   /technician-inventories
#   - POST   /technician-inventories/technician/{technicianId}/stocks
#   - PUT    /technician-inventories/technician/{technicianId}/stocks/{componentId}
#   - DELETE /technician-inventories/technician/{technicianId}/stocks/{componentId}
# ─────────────────────────────────────────────────────────────────

Feature: Technician Inventory module - full inventory management

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * def authToken = auth.authToken
    * header Authorization = 'Bearer ' + authToken
    * def testData = read('classpath:common/test-data.json')

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/low-stock
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get inventories with low stock returns matching inventories
    Given path '/technician-inventories/low-stock'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match each response ==
      """
      {
        "id":           '#number',
        "technicianId": '#number',
        "stocks":       '#array'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get a single stock item by technician and component id
    Given path '/technician-inventories/technician', 1, 'stocks', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "componentId":    '#number',
        "quantity":       '#number',
        "alertThreshold": '#number',
        "lastUpdated":    '#string'
      }
      """
    And match response.componentId == 1

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/technician/{technicianId}
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get full inventory by technician id
    Given path '/technician-inventories/technician', 1
    When method GET
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "technicianId": '#number',
        "stocks":       '#array'
      }
      """
    And match response.technicianId == 1

  # ────────────────────────────────────────────────────────────────
  # POST /technician-inventories — create authenticated inventory
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @post
  Scenario: Create technician inventory for the authenticated user
    Given path '/technician-inventories'
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id":           '#number',
        "technicianId": '#number',
        "stocks":       '#array'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # POST /technician-inventories/technician/{technicianId}/stocks
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @post
  Scenario: Add a component to the technician stock
    Given path '/technician-inventories/technician', 1, 'stocks'
    And request testData.newStock
    When method POST
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "technicianId": '#number',
        "stocks":       '#array'
      }
      """
    And match response.stocks[*].componentId contains 1

  # ────────────────────────────────────────────────────────────────
  # PUT /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @put
  Scenario: Update a stock item quantity and alertThreshold
    Given path '/technician-inventories/technician', 1, 'stocks', 1
    And request testData.updateStock
    When method PUT
    Then status 200
    And match response ==
      """
      {
        "id":           '#number',
        "technicianId": '#number',
        "stocks":       '#array'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # DELETE /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @delete
  Scenario: Delete a stock item from technician inventory
    Given path '/technician-inventories/technician', 1, 'stocks', 1
    When method DELETE
    Then status 204
