Feature: Search

  Scenario: Members by name with exact match
    Given I am logged in as an admin
    And the following members exist:
      | name    | active |
      | Tsigo   | false  |
      | Sebudai | true   |
    When I search for "Tsigo" in "members"
    Then I should be on the member page for Tsigo

  Scenario: Members by name with multiple matches
    Given the following members exist:
      | name      | active |
      | Tsigo     | false  |
      | Eviltsi   | true   |
      | Sebudai   | true   |
    When I search for "Tsi" in "members"
    Then I should see "Tsigo"
    And I should see "Eviltsi"

  Scenario: Members by class
    Given the following members exist:
      | name       | active | wow_class |
      | Duskshadow | true   | Priest    |
      | Tsigo      | true   | Priest    |
      | Sebudai    | true   | Hunter    |
      | Aquan      | false  | Priest    |
    When I search for "Priest" in "members"
    Then I should see "Tsigo"
    But I should not see "Aquan"
    And I should not see "Sebudai"

  Scenario: Items by name with exact match
    Given the following items exist:
      | id    | name                  |
      | 32837 | Warglaive of Azzinoth |
      | 40395 | Torch of Holy Fire    |
    When I search for "Warg" in "items"
    Then I should be on the item page for Warglaive of Azzinoth

  Scenario: Items by name with multiple matches
    Given the following items exist:
      | id    | name                         |
      | 32837 | Warglaive of Azzinoth (Main) |
      | 32838 | Warglaive of Azzinoth (Off)  |
      | 40395 | Torch of Holy Fire           |
    When I search for "Warg" in "items"
    Then I should see "Warglaive of Azzinoth (Main)"
    And I should see "Warglaive of Azzinoth (Off)"

  Scenario: Items by name with Wowhead matching
    Given the following items exist:
      | id    | name                               |
      | 52030 | Conqueror's Mark of Sanctification |
    When I search for "conq sanc" in "items"
    Then I should be on the item page for Conqueror's Mark of Sanctification

  Scenario: Using an invalid context
    Given the following members exist:
      | name    |
      | Tsigo   |
      | Eviltsi |
    When I search for "Tsi" in "raids"
    Then I should see "Tsigo"
    And I should see "Eviltsi"

  Scenario: Requesting json
    Given the following items exist:
      | name                  |
      | Warglaive of Azzinoth |
      | Warglaive of Azzinoth |
    When I search for "Warg" in "items" as json
    Then I should see "Warglaive of Azzinoth"
    And I should see "id"
    And I should see "name"
    But I should not see "created_at"
    And I should not see "updated_at"

  Scenario: Requesting xml
    Given the following items exist:
      | name                  |
      | Warglaive of Azzinoth |
      | Warglaive of Azzinoth |
    When I search for "Warg" in "items" as xml
    Then I should see "Warglaive of Azzinoth"
    But I should not see "created_at"
    And I should not see "updated_at"
