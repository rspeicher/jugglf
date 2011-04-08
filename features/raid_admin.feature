Feature: Raid Administration
  Background:
    Given I am logged in as an admin

  Scenario: Adding a raid creates new members
    Given I am on the add raid page
    When I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      """
    And I press "Add Raid"
    Then the following members should exist:
     | name    | attendance_30 | active | raids_count |
     | Baud    | 1.0           | 1      | 1           |
     | Sebudai | 0.5           | 1      | 1           |

  Scenario: Editing a raid creates new members
    Given I am on the add raid page
    And I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      """
    And I press "Add Raid"
    When I go to edit the last raid
    And I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      Alephone,0.75,75
      """
    And I press "Save Raid"
    Then the following members should exist:
     | name     | attendance_30 | active | raids_count |
     | Baud     | 1.0           | 1      | 1           |
     | Sebudai  | 0.5           | 1      | 1           |
     | Alephone | 0.75          | 1      | 1           |

  Scenario: Adding a raid updates loot factor cache
    Given a member exists with a name of "Tsigo"
    And I am on the add raid page
    When I fill in "Attendance" with "Tsigo,0.75,100"
    And I press "Add Raid"
    Then the following member should exist:
      | name  | Attendance_30 |
      | Tsigo | 0.75          |
