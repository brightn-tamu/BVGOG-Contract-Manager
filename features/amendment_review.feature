Feature: Reviewing Amendments

	As a Gatekeeper user,
	I want to be able to reject amendments
	So that amendments with inaccurate information do not populate the database.

Background:
    Given 2 example entities exist
    Given 2 example programs exist
    Given an example user exists
    Given 1 example vendors exist
	Given 7 example amendments exist
	Given 3 example review amendments exist
	Given I am logged in as a level 2 user
	Given I am on the contracts page
    Given the contract "Amendment 2" has a modification log

Scenario: Gatekeeper rejects an amendment
	When I follow "Amendment 2"
	When I follow Set to "Rejected"
	And I fill in the "Rejection Reason" field with "test reason"
	And I press "commit"
	Then I should see "Amendment request was rejected."
	And the latest modification log should have status "rejected"
	And the latest modification log should have remarks "test reason"

Scenario: Rejecting an amendment removes associated documents
	Given the amendment has associated documents
	When I follow "Amendment 7"
	When I follow Set to "Rejected"
	And I fill in the "Rejection Reason" field with "test reason"
	And I press "commit"
	Then I should see "Amendment request was rejected."
	And the documents added during the amendment should be removed

Scenario: Gatekeeper approves an amendment with changes
    Given the contract "Amendments 1" has a pending modification log
    When I follow "Amendments 1"
    When I press Set to "Approved"
    Then I should see "Amendment request was Approved"
    And the latest modification log should have status "approved"
    And the changes in the modification log should be applied to the contract


