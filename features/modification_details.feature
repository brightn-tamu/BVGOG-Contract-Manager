Feature: Reviewing contracts

	As a Gatekeeper user,
	I want to be able to reject contracts
	So that contracts with inaccurate information do not populate the database.

Background:
	Given 1 example entities exist
	Given 1 example programs exist
	Given 1 example users exist
	Given 1 example vendors exist
	Given 15 example contracts exist
	Given I am logged in as a level 1 user

Scenario: View contract details with pending modifications
	Given I have a contract with attributes:
		| field          | value                     |
		| title          | Contract 1               |
		| number         | 12345                    |
		| contract_status| IN_PROGRESS              |
		| starts_at      | 2023-01-01               |
		| ends_at        | 2023-12-31               |
		| total_amount   | 10000                    |
		| description    | Original Contract Description |
	And the contract has a pending modification log with changes:
		| field          | old_value                 | new_value                 |
		| number         | 12345                     | 54321                     |
		| starts_at      | 2023-01-01                | 2023-02-01                |
		| ends_at        | 2023-12-31                | 2023-11-30                |
		| total_amount   | 10000                     | 15000                     |
		| description    | Original Contract Description | Modified Contract Description |
	When I visit the contract page for contract "12345"
	Then I should see the differences for:
		| field           |
		| Contract ID     |
		| Start Date      |
		| End Date        |
		| Contract Value  |
		| Summary         |
