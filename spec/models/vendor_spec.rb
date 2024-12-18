# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendor, type: :model do
    include FactoryBot::Syntax::Methods

    it 'does not save vendor without name' do
        vendor = build(:vendor, name: nil)
        expect { vendor.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'saves vendor with name' do
        vendor = build(:vendor, name: 'New Vendor')
        expect { vendor.save! }.not_to raise_error
    end

    it 'does not save vendor with duplicate name' do
        create(:vendor, name: 'New Vendor')
        vendor_two = build(:vendor, name: 'New Vendor')
        expect { vendor_two.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'queries all reviews for a vendor' do
        vendor = create(:vendor)
        vendor_review_one = create(:vendor_review, vendor:)
        vendor_review_two = create(:vendor_review, vendor:)
        expect(vendor.vendor_reviews).to include(vendor_review_one)
        expect(vendor.vendor_reviews).to include(vendor_review_two)
    end

    it 'queries all contracts for a vendor' do
        vendor = create(:vendor)
        contract_one = create(:contract, vendor:)
        contract_two = create(:contract, vendor:)
        expect(vendor.contracts).to include(contract_one)
        expect(vendor.contracts).to include(contract_two)
    end
end
