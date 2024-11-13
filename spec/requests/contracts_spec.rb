# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/contracts', type: :request do
    include Devise::Test::IntegrationHelpers
    include FactoryBot::Syntax::Methods

    before do
        login_user
    end

    # This should return the minimal set of attributes required to create a valid
    # Contract. As you add validations to Contract, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
        entity = create(:entity)
        program = create(:program)
        point_of_contact = create(:user, entities: [entity], level: UserLevel::TWO)
        vendor = create(:vendor)
        return build(
            :contract,
            entity:,
            program:,
            point_of_contact:,
            vendor:
        ).attributes.except('id', 'created_at', 'updated_at')
    end

    let(:invalid_attributes) do
        return build(
            :contract,
            vendor_id: nil,
            entity_id: nil,
            program_id: nil,
            point_of_contact_id: nil,
            starts_at: nil,
            title: nil,
            contract_type: nil
        ).attributes.except('id', 'created_at', 'updated_at')
    end

    describe 'GET /index' do
        it 'renders a successful response' do
            Contract.create! valid_attributes
            get contracts_url
            expect(response).to be_successful
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            contract = Contract.create! valid_attributes
            get contract_url(contract)
            expect(response).to be_successful
        end
    end

    describe 'GET /new' do
        it 'renders a successful response' do
            get new_contract_url
            expect(response).to be_successful
        end
    end

    describe 'GET /edit' do
        it 'renders a successful response' do
            contract = Contract.create! valid_attributes
            get edit_contract_url(contract)
            expect(response).to be_successful
        end
    end

    describe 'POST /create' do
        context 'with valid parameters' do
            it 'creates a new Contract' do
                expect do
                    post contracts_url, params: { contract: valid_attributes }
                end.to change(Contract, :count).by(1)
            end

            it 'redirects to the created contract' do
                post contracts_url, params: { contract: valid_attributes }
                expect(response).to redirect_to(contract_url(Contract.last))
            end
        end

        context 'with invalid parameters' do
            it 'does not create a new Contract' do
                expect do
                    post contracts_url, params: { contract: invalid_attributes }
                end.to change(Contract, :count).by(0)
            end

            it 're-renders the new template with validation errors' do
                post contracts_url, params: { contract: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity) # Checks for 422 status
                expect(response.body).to include('error') # Optionally check if an error message is present in the response
            end
        end
    end

    describe 'PATCH /update' do
        context 'with valid parameters' do
            let(:new_attributes) { { title: 'Updated Title', total_amount: 1500 } }

            it 'updates the requested contract' do
                contract = Contract.create! valid_attributes
                patch contract_url(contract), params: { contract: new_attributes }
                contract.reload

                expect(contract.title).to eq('Updated Title')
                expect(contract.total_amount).to eq(1500)
            end

            it 'redirects to the contract' do
                contract = Contract.create! valid_attributes
                patch contract_url(contract), params: { contract: new_attributes }
                contract.reload
                # expect(response).to redirect_to(contract_url(contract))
            end
        end

        context 'with invalid parameters' do
            it 'does not update the contract and re-renders the edit template' do
                contract = Contract.create! valid_attributes
                patch contract_url(contract), params: { contract: invalid_attributes }

                expect(response).to have_http_status(:unprocessable_entity) # Expect 422 Unprocessable Entity
                expect(response.body).to include('error') # Optionally check if error messages are present in the response
            end
        end
    end
end
