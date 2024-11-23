# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/show', type: :view do
	include Devise::Test::IntegrationHelpers
	include Devise::Test::ControllerHelpers
	include FactoryBot::Syntax::Methods

	before do
		login_user
		@vendor = create(:vendor)
		@entity = create(:entity)
		@program = create(:program)
		@point_of_contact = create(:user)

		@contract = assign(:contract, create(
			:contract,
			vendor: @vendor,
			entity: @entity,
			program: @program,
			point_of_contact: @point_of_contact,
			contract_status: ContractStatus::IN_PROGRESS
		))

		@modification_log = create(
			:modification_log,
			contract: @contract
		)

		render
	end

	it 'renders the contract title' do
		expect(rendered).to include(@contract.title)
	end

	it 'renders the contract ID with modification log differences' do
		old_number = @modification_log.changes_made['number'].first
		new_number = @modification_log.changes_made['number'].last
		expect(rendered).to include(old_number)
		expect(rendered).to include(new_number)
	end

	it 'renders the contract type' do
		expect(rendered).to include(@contract.current_type)
	end

	it 'renders the point of contact link' do
		point_of_contact_name = "#{@point_of_contact.first_name} #{@point_of_contact.last_name}"
		expect(rendered).to include(point_of_contact_name)
	  end

	it 'renders the vendor link' do
		expect(rendered).to include(@vendor.name)
	end

	it 'renders the funding source, or N/A if not present' do
		if @contract.funding_source.present?
		expect(rendered).to include(@contract.funding_source)
		else
		expect(rendered).to include('N/A')
		end
	end

	it 'renders the entity name' do
		expect(rendered).to include(@entity.name)
	end

	it 'renders the program name' do
		expect(rendered).to include(@program.name)
	end

	it 'renders the start date with modification log differences' do
		old_starts_at = Date.parse(@modification_log.changes_made['starts_at'].first).strftime("%B %d, %Y")
		new_starts_at = Date.parse(@modification_log.changes_made['starts_at'].last).strftime("%B %d, %Y")
		expect(rendered).to include(old_starts_at)
		expect(rendered).to include(new_starts_at)
	end

	it 'renders the end date with modification log differences' do
		old_ends_at = Date.parse(@modification_log.changes_made['ends_at'].first).strftime("%B %d, %Y")
		new_ends_at = Date.parse(@modification_log.changes_made['ends_at'].last).strftime("%B %d, %Y")
		expect(rendered).to include(old_ends_at)
		expect(rendered).to include(new_ends_at)
	end

	it 'renders the contract value with modification log differences' do
		old_total_amount = number_to_currency(@modification_log.changes_made['total_amount'].first)
		new_total_amount = number_to_currency(@modification_log.changes_made['total_amount'].last)
		expect(rendered).to include(old_total_amount)
		expect(rendered).to include(new_total_amount)
	end

	it 'renders the description with modification log differences' do
		old_description = @modification_log.changes_made['description'].first
		new_description = @modification_log.changes_made['description'].last
		expect(rendered).to include(old_description)
		expect(rendered).to include(new_description)
	end
end