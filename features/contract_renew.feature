Feature: Renew contracts

	As a level 3 user (of any level)
	So that I can update an existing contract
	I want to renew contracts in the database


Background:
	Given 1 example entities exist
	Given 1 example programs exist
	Given an example user exists
	Given 1 example vendors exist
	Given 1 example contracts exist
	Given I am logged in as a level 3 user
	Given I am on the renew page

Scenario: Renew contract successfully
    When I select "Continuous" from the Length of Contract dropdown
    And I fill in "Effective Date" with "2025/01/01"
    And I press "Submitquest"  
	Then I should see "Contract was successfully updated."

Scenario: Renew contract with blank
	And I press "Submit request"
	Then I should see "Renewal request for Contract 1 submitted successfully and is pending approval."

Scenario: Renew an expired contract
    When I select "continuous" from the length_of_contract
    And I fill in the "Effective Date" with "2025/01/01"
    And I press "submit request"  
	Then I should see "Renewal request for Expiry Contract 1 submitted successfully and is pending approval."
