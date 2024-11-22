Feature: Edit amendments with modification logs

    As a platform user (of any level)
    So that I can manage contract amendments effectively
    I want to update contracts of type "amend" and handle modification logs properly

Background:
    Given 1 example entities exist
    Given 1 example programs exist
    Given an example user exists
    Given 1 example vendors exist
    Given 1 example amendments exist
    And I am logged in as a level 1 user
    And I am on the contracts page

Scenario: Create a new modification log when the latest log is rejected
    Given the latest modification log exists with status "rejected"
    When I follow "Amendment 1"
    And I follow "Edit this request"
    And I fill in "contract[number]" with "223"
    And I press "Update Contract"
    Then I should see "Contract was successfully updated."
    And a new modification log should be created with status "pending"

Scenario: Update the latest modification log when the latest log is pending
    Given the latest modification log exists with status "pending"
    When I follow "Amendment 1"
    And I follow "Edit this request"
    And I fill in "contract[number]" with "223"
    And I press "Update Contract"
    Then I should see "Contract was successfully updated."
