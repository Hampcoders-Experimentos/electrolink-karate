# technicianinventories/technician-inventories.feature
# ─────────────────────────────────────────────────────────────────
# Technician Inventory Module — Integration tests.
# Base Path: /api/v1/technician-inventories
# ─────────────────────────────────────────────────────────────────

Feature: Technician Inventory module - full inventory management

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def tech = callonce read('classpath:common/seed-helper.feature@technicianIdentity')
    * def comp = callonce read('classpath:common/seed-helper.feature@component')
    * def stockBody = karate.merge(testData.newStock, { componentId: comp.componentId })

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/low-stock
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get inventories with low stock returns matching inventories
    Given path '/technician-inventories/low-stock'
    When method GET
    Then status 200
    And match response == '#array'
    * eval matchEachOrEmpty(response, { inventoryId: '#uuid', technicianId: '#number', stock: '#array' })

  # ────────────────────────────────────────────────────────────────
  # POST /technician-inventories — create authenticated inventory
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @post
  Scenario: Technician inventory exists for the authenticated user
    Given path '/technician-inventories/technician', tech.technicianId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "inventoryId":  '#uuid',
        "technicianId": '#number',
        "stock":        '#array'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/technician/{technicianId}
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get full inventory by technician id
    Given path '/technician-inventories/technician', tech.technicianId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "inventoryId":  '#uuid',
        "technicianId": '#number',
        "stock":        '#array'
      }
      """
    And match response.technicianId == tech.technicianId

  # ────────────────────────────────────────────────────────────────
  # POST /technician-inventories/technician/{technicianId}/stocks
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @post
  Scenario: Add a component to the technician stock
    Given path '/technician-inventories/technician', tech.technicianId, 'stocks'
    And request stockBody
    When method POST
    Then status 200
    And match response ==
      """
      {
        "inventoryId":  '#uuid',
        "technicianId": '#number',
        "stock":        '#array'
      }
      """
    And match response.stock[*].componentId contains comp.componentId

  # ────────────────────────────────────────────────────────────────
  # GET /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @smoke @inventories @get
  Scenario: Get a single stock item by technician and component id
    Given path '/technician-inventories/technician', tech.technicianId, 'stocks', comp.componentId
    When method GET
    Then status 200
    And match response ==
      """
      {
        "componentStockId":  '#uuid',
        "componentId":       '#number',
        "componentName":     '##string',
        "quantityAvailable": '#number',
        "alertThreshold":    '#number',
        "lastUpdated":       '#string'
      }
      """
    And match response.componentId == comp.componentId

  # ────────────────────────────────────────────────────────────────
  # PUT /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @put
  Scenario: Update a stock item quantity and alertThreshold
    Given path '/technician-inventories/technician', tech.technicianId, 'stocks', comp.componentId
    And request testData.updateStock
    When method PUT
    Then status 200
    And match response ==
      """
      {
        "inventoryId":  '#uuid',
        "technicianId": '#number',
        "stock":        '#array'
      }
      """

  # ────────────────────────────────────────────────────────────────
  # DELETE /technician-inventories/technician/{technicianId}/stocks/{componentId}
  # ────────────────────────────────────────────────────────────────
  @regression @inventories @delete
  Scenario: Delete a stock item from technician inventory
    Given path '/technician-inventories/technician', tech.technicianId, 'stocks', comp.componentId
    When method DELETE
    Then status 204
