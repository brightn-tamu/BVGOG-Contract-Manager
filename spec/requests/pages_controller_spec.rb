# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PagesController', type: :request do
    include Devise::Test::IntegrationHelpers
    include FactoryBot::Syntax::Methods

    before do
        @entity = create(:entity)
        @user_level_3 = create(:user, level: UserLevel::THREE, entities: [@entity])
        @user_level_2 = create(:user, level: UserLevel::TWO, entities: [@entity])
        @contract_in_progress = create(:contract, entity: @entity, contract_status: ContractStatus::IN_PROGRESS)
        @contract_in_review = create(:contract, entity: @entity, contract_status: ContractStatus::IN_REVIEW)
    end

    describe 'GET /' do
        context 'when the user is level 3' do
            it 'displays contracts in progress' do
                sign_in @user_level_3
                get root_path

                expect(response).to have_http_status(:success)
                expect(response.body).to include(@contract_in_progress.title) # Ensure in-progress contract is shown
                expect(response.body).not_to include(@contract_in_review.title) # Ensure in-review contract is not shown
            end
        end

        context 'when the user is not level 3' do
            it 'displays contracts in review' do
                sign_in @user_level_2
                get root_path

                expect(response).to have_http_status(:success)
                expect(response.body).to include(@contract_in_review.title) # Ensure in-review contract is shown
                expect(response.body).not_to include(@contract_in_progress.title) # Ensure in-progress contract is not shown
            end
        end
    end
end
