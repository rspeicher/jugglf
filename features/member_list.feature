Feature: Member List

  Scenario: Viewing member list as a guest
    Given I am not logged in
    And the following member exists:
      | name  | attendance_30 | lf   |
      | Tsigo | 1.00          | 5.00 |
    When I go to the members index
    Then I should see "Tsigo"
    And I should see "30-Day" within a table header
    And I should see "100%" within "td.attendance span"
    And I should not see "Best in Slot"
    And I should not see "Situational"

  Scenario: Viewing member list as a member
    Given I am logged in as a user
    And the following member exists:
      | name  | attendance_30 | lf   |
      | Tsigo | 1.00          | 5.00 |
    When I go to the members index
    Then I should see "Tsigo"
    And I should see "30-Day" within a table header
    And I should see "100%" within "td.attendance span"
    And I should not see "Best in Slot"
    And I should not see "Situational"

  Scenario: Viewing member list as an administrator
    Given I am logged in as an admin
    And the following member exists:
      | name  | attendance_30 | lf   |
      | Tsigo | 1.00          | 5.00 |
    When I go to the members index
    Then I should see "Tsigo"
    And I should see "100%" within "td.attendance"
    And I should see "5.00" within "td.lootfactor"
