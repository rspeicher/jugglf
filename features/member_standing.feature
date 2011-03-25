Feature: Member standing

  Scenario: Member viewing their own page
    Given I am logged in as a user with an associated member
    When I go to the home page
    And I follow "My Standing"
    Then I should be on my standing page

  Scenario: Member trying to view another member's page
    Given I am logged in as a user
    And a member exists with a name of "Sebudai"
    When I go to the member page for Sebudai
    Then I should be on the home page
    And I should see "You do not have permission to access that page."

  Scenario: Admin viewing another member's page
    Given I am logged in as an admin
    And a member exists with a name of "Sebudai"
    When I go to the member page for Sebudai
    Then I should be on the member page for Sebudai
