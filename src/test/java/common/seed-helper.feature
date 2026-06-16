# common/seed-helper.feature
# ─────────────────────────────────────────────────────────────────
# Shared seeding helper for cross-entity business rules.
# ─────────────────────────────────────────────────────────────────

@ignore
Feature: Monitoring seed helper

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:common/auth-helper.feature@signIn')
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    * def testData = read('classpath:common/test-data.json')
    * def uniqueRequestId = Java.type('java.util.concurrent.ThreadLocalRandom').current().nextInt(1, 2000000000)

  @serviceOperation
  Scenario: Create a service operation
    Given path '/service-operations'
    And request karate.merge(testData.newServiceOperation, { requestId: uniqueRequestId })
    When method POST
    Then status 201
    * def soId = response.id
    * def requestId = response.requestId
    * def technicianId = response.technicianId

  @completedServiceOperation
  Scenario: Create a completed service operation
    Given path '/service-operations'
    And request karate.merge(testData.newServiceOperation, { requestId: uniqueRequestId })
    When method POST
    Then status 201
    * def soId = response.id
    * def requestId = response.requestId
    * def technicianId = response.technicianId

    Given path '/service-operations/status'
    And request { serviceOperationId: '#(soId)', newStatus: 'COMPLETED' }
    When method PUT
    Then status 204

  @plan
  Scenario: Use (or seed) a subscription plan
    Given path '/plans'
    When method GET
    Then status 200
    * def planList = response
    * def planId = planList.length > 0 ? planList[0].id : karate.call('classpath:common/seed-helper.feature@createPlan').planId

  @createPlan
  Scenario: Ensure a subscription plan exists and expose its id
    Given path '/plans'
    When method GET
    Then status 200
    * def planId = response.length > 0 ? response[0].id : null
    # A plan already exists - reuse it; abort keeps planId available to the caller.
    * if (planId != null) karate.abort()

    # Catalog is empty - BASIC is a free enum name.
    Given path '/plans'
    And request { name: 'BASIC', description: 'Seed plan', price: 0.0, maxRequestsPerMonth: 100000, prioritySupport: false }
    When method POST
    Then status 201
    * def planId = response.id

  @clientSubscription
  Scenario: Ensure user 1 has an active subscription
    Given path '/plans'
    When method GET
    Then status 200
    * def planList = response
    # POST /requests counts against the plan's maxRequestsPerMonth; pick the plan with the
    # most monthly headroom (the subscription upgrade below resets the count to 0).
    * def pickAmplePlan = function(plans){ var best = plans[0]; for (var i = 1; i < plans.length; i++) { if (plans[i].maxRequestsPerMonth > best.maxRequestsPerMonth) best = plans[i]; } return best; }
    * def planId = planList.length > 0 ? pickAmplePlan(planList).id : karate.call('classpath:common/seed-helper.feature@createPlan').planId

    Given path '/subscriptions'
    And request { userId: 1, planId: '#(planId)' }
    When method POST
    Then status 201
    * def clientId = '1'

  @technicianIdentity
  Scenario: Ensure the auth user is a technician with an inventory
    * def email = testUser.username
    # Profiles are public - search/create without the bearer token.
    * configure headers = null
    Given path '/profiles/search'
    And param email = email
    When method GET
    Then status 200
    * def profile = response.length > 0 ? response[0] : karate.call('classpath:common/seed-helper.feature@createTechnicianProfile', { email: email }).profile

    # Inventory creation is protected - re-attach the bearer.
    * configure headers = { 'Content-Type': 'application/json', 'Accept': 'application/json', Authorization: 'Bearer ' + auth.authToken }
    Given path '/technician-inventories'
    When method POST
    # 201 first time; 500 if this technician already has an inventory (no delete endpoint).
    * def technicianId = responseStatus == 201 ? response.technicianId : profile.id

  @createTechnicianProfile
  Scenario: Create a TECHNICIAN profile
    * configure headers = null
    Given path '/profiles'
    And request { firstName: 'Seed', lastName: 'Technician', email: '#(email)', street: 'Seed St 1', role: 'TECHNICIAN', additionalInfoOrCertification: 'seed' }
    When method POST
    Then status 201
    * def profile = response

  @component
  Scenario: Create a component for stock tests
    * def uniqueName = 'StockComponent_' + java.util.UUID.randomUUID()
    Given path '/components'
    And request { name: '#(uniqueName)', description: 'Seed component for stock', componentTypeId: 1, isActive: true }
    When method POST
    Then status 201
    * def componentId = response.id * 1

  @report
  Scenario: Create a report
    Given path '/service-operations'
    And request karate.merge(testData.newServiceOperation, { requestId: uniqueRequestId })
    When method POST
    Then status 201
    * def soId = response.id

    * def reportBody = karate.merge(testData.newReport, { serviceOperationId: soId })
    Given path '/reports'
    And request reportBody
    When method POST
    Then status 201
    * def reportId = response.id
