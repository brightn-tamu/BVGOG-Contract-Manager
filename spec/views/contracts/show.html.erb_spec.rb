# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'

RSpec.describe 'contracts/show', type: :view do
    include Devise::Test::IntegrationHelpers
    include Devise::Test::ControllerHelpers
    include FactoryBot::Syntax::Methods

    before do
        login_user
        vendor = create(:vendor)
        entity = create(:entity)
        program = create(:program)
        point_of_contact = create(:user)
      
        @contract = assign(:contract, create(
            :contract,
            vendor: vendor,
            entity: entity,
            program: program,
            point_of_contact: point_of_contact,
            contract_status: ContractStatus::IN_PROGRESS,
        ))
        user = create(:user)
        @modification_log = create(
          :modification_log,
          contract: @contract,
          status: 'pending',
          changes_made: {
            'number' => ['123', '456'],
            'starts_at' => ['2023-01-01', '2024-01-01'],
            'ends_at' => ['2023-12-31', '2024-12-31'],
            'total_amount' => [1000, 1500],
            'description' => ['Old Description', 'New Description']
          },
          modified_by: user,
          modification_type: 'amend',
        )
        render
    end


    it 'renders the contract title' do
        expect(rendered).to include(@contract.title)
    end
    
    it 'renders the contract ID with modification log differences' do
        expect(rendered).to include('123')
        expect(rendered).to include('456')
    end
    
    it 'renders the contract type' do
        expect(rendered).to include(@contract.contract_type_humanize)
    end
    
    it 'renders the point of contact link' do
        expect(rendered).to include(user_path(@contract.point_of_contact))
        expect(rendered).to include(@contract.point_of_contact.full_name)
    end
    
    it 'renders the vendor link' do
        expect(rendered).to include(vendor_path(@contract.vendor))
        expect(rendered).to include(@contract.vendor.name)
    end
    
    it 'renders the funding source, or N/A if not present' do
        if @contract.funding_source.present?
          expect(rendered).to include(@contract.funding_source)
        else
          expect(rendered).to include('N/A')
        end
    end
    
    it 'renders the entity name' do
        expect(rendered).to include(@contract.entity.name)
    end
    
    it 'renders the program name' do
        expect(rendered).to include(@contract.program.name)
    end
    
    it 'renders the start date with modification log differences' do
        expect(rendered).to include('January 01, 2023')
        expect(rendered).to include('January 01, 2024')
    end
    
    it 'renders the end date with modification log differences' do
        expect(rendered).to include('December 31, 2023')
        expect(rendered).to include('December 31, 2024')
    end
    
    it 'renders the contract value with modification log differences' do
        expect(rendered).to include('1,000.00')
        expect(rendered).to include('1,500.00')
    end
    
    it 'renders the description with modification log differences' do
        expect(rendered).to include('Old Description')
        expect(rendered).to include('New Description')
    end
end