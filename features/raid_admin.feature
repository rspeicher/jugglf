Feature: Raid Administration

  Scenario: Add a new raid
    Given I am logged in as an admin
    And I am on the add raid page
    When I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      """
    And I press "Add Raid"
    Then I should be on the last raid's page
    When I go to the members index
    Then I should see "Sebudai"
    And I should see "Baud"

  Scenario: Edit a raid, adding a new member
    Given I am logged in as an admin
    And I am on the add raid page
    When I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      """
    And I press "Add Raid"
    And I go to edit the last raid
    And I fill in "Attendance" with:
      """
      Baud,1.0,100
      Sebudai,0.5,50
      Alephone,0.75,75
      """
    And I press "Save Raid"
    When I go to the members index
    Then I should see "Sebudai"
    And I should see "Baud"
    And I should see "Alephone"
